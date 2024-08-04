import { getFirestore } from "firebase-admin/firestore";
import { onCall, CallableRequest } from "firebase-functions/v2/https";
import { Activity } from "../models/activity";
import { Client } from "../models/client";
import { ClientType } from "../models/client_type";
import { Coach } from "../models/coach";
import { CoachRecomendation } from "../models/coach_recommendation";
import { CoachTravelEstimate } from "../models/coach_travel_estimate";
import { QoutaInfo } from "../models/qouta_info";
import { BookingSession, BookingSessionData } from "../models/session";
import { TravelEstimate } from "../models/travel_estimate";
import { defineSecret } from "firebase-functions/params";
import { AssignedCoach } from "../models/assigned_coach";
import { Leave, LeaveStatus } from "../models/leave";

const mapsApiKey = defineSecret('MAPS_API_KEY');
export const find_sessions_available_coaches_function = onCall({ secrets: [mapsApiKey] }, async (request: CallableRequest) => {


    const sessionData: {
        id: string;
        arrivalTime: number;
        leaveTime: number;
        startTime: number;
        endTime: number;
        activity: {
            id: string;
            name: string;
            icon: string;
            color: string;
        };
        assignedCoaches: AssignedCoach[];
        coaches: string[];
        client: {
            id: string;
            name: string;
            addressLineOne: string;
            addressLineTwo: string;
            eircode: string;
            rollNumber: string;
            type: {
                id: string;
                name: string;
            };
        };
    } = request.data.session;
    //Arrival Times are in milliseconds since epoch - put in date
    const session = new BookingSession({
        id: sessionData.id,
        arrivalTime: new Date(sessionData.arrivalTime),
        leaveTime: new Date(sessionData.leaveTime),
        startTime: new Date(sessionData.startTime),
        endTime: new Date(sessionData
            .endTime),
        activity: new Activity(
            sessionData.activity.id, sessionData.activity.name, sessionData.activity.icon, sessionData.activity.color,
        ),
        assignedCoaches: sessionData.assignedCoaches,
        coaches: sessionData.coaches,
        client: new Client({
            id: sessionData.client.id,
            name: sessionData.client.name,
            addressLineOne: sessionData.client.addressLineOne,
            addressLineTwo: sessionData.client.addressLineTwo,
            eircode: sessionData.client.eircode,
            rollNumber: sessionData.client.rollNumber,
            clientType: new ClientType(
                sessionData.client.type.id, sessionData.client.type.name,
            ),
        }),
    });

    const db = getFirestore();

    const coachesWhoCoverActivityRef = db.collection('users').where('activitiesCovered', 'array-contains', session.activity.id);
    const coachesWhoCoverActivityDocs = await coachesWhoCoverActivityRef.get();
    if (coachesWhoCoverActivityDocs.empty) {
        console.log('No Coaches Found');
        return [];
    }


    const coachesWhoCoverActivity: Coach[] = coachesWhoCoverActivityDocs.docs.map((doc: any) => {
        const coach = doc.data();
        if (coach.baseEircode == undefined) {
            console.log(`${coach.name} does not have a base eircode`);
            return;
        } else {
            console.log(`${coach.name} has a base eircode - ${coach.baseEircode}`);
        }
        return new Coach({
            uid: doc.id,
            name: coach.name,
            baseEircode: coach.baseEircode,
            activitiesCovered: coach.activitiesCovered,
            timeToCover: coach.timeToCover,
        });
    }).filter((coach: Coach | undefined): coach is Coach => coach !== undefined);

    const baseQuery = db.collection('sessions').where('coaches', 'array-contains-any', coachesWhoCoverActivity.map(coach => coach.uid));


    const fullOverlapSession = await baseQuery.where('arrivalTime', '<=', session.arrivalTime).where('leaveTime', '>=', session.endTime).get();
    const beginningOverlapSession = await baseQuery.where('arrivalTime', '>=', session.arrivalTime).where('arrivalTime', '<=', session.endTime).get();
    const endOverlapSession = await baseQuery.where('leaveTime', '>=', session.arrivalTime).where('leaveTime', '<=', session.endTime).get();

    const overlappingSessionDocs = fullOverlapSession.docs.concat(beginningOverlapSession.docs).concat(endOverlapSession.docs);
    const overlappingSessions: BookingSession[] = overlappingSessionDocs.map((doc: any) => {
        const session: BookingSessionData = doc.data();
        return new BookingSession({
            id: doc.id,
            arrivalTime: session.arrivalTime.toDate(),
            leaveTime: session.leaveTime.toDate(),
            startTime: session.startTime.toDate(),
            endTime: session.endTime.toDate(),
            coaches: session.coaches,
            activity: new Activity(
                session.activity.id, session.activity.name, session.activity.icon, session.activity.color,
            ),
            client: new Client({
                id: session.client.id,
                name: session.client.name,
                addressLineOne: session.client.addressLineOne,
                addressLineTwo: session.client.addressLineTwo,
                eircode: session.client.eircode,
                rollNumber: session.client.rollNumber,
                clientType: new ClientType(session.client.type.id, session.client.type.name),
            }),
            assignedCoaches: session.assignedCoaches,
        });
    });

    const overlappingCoachesUids = overlappingSessions.map(session => session.coaches).flat();

    const notWorkingCoachesWhoCoverActivity = coachesWhoCoverActivity.filter(coach => !overlappingCoachesUids.includes(coach.uid));

    //Now Filter For Coaches who are not on leave
    const leaveRef = db.collection('leaves');
    const leaveDocs = await leaveRef.where('coachUid', 'in', notWorkingCoachesWhoCoverActivity.map(coach => coach.uid)).get();
    const leaves: Leave[] = leaveDocs.docs.map((doc: any) => {
        const leave = doc.data();
        return {
            id: doc.id,
            coachUid: leave.coachUid,
            startDate: leave.startDate.toDate(),
            endDate: leave.endDate.toDate(),
            type: leave.type,
            status: leave.status,
        };
    });

    const onLeaveCoaches: Coach[] = [];
    for (const leave of leaves) {
        if (leave.status != LeaveStatus.rejected) {
            if (leave.startDate <= session.arrivalTime && leave.endDate >= session.endTime) {
                onLeaveCoaches.push(notWorkingCoachesWhoCoverActivity.find(coach => coach.uid === leave.coachUid) as Coach);
            }
            if (leave.startDate >= session.arrivalTime && leave.startDate <= session.endTime) {
                onLeaveCoaches.push(notWorkingCoachesWhoCoverActivity.find(coach => coach.uid === leave.coachUid) as Coach);
            }
            if (leave.endDate >= session.arrivalTime && leave.endDate <= session.endTime) {
                onLeaveCoaches.push(notWorkingCoachesWhoCoverActivity.find(coach => coach.uid === leave.coachUid) as Coach);
            }
        }
    }

    const availableCoachesWhoCoverActivity = notWorkingCoachesWhoCoverActivity.filter(coach => !onLeaveCoaches.includes(coach));









    let coachRecommendations: CoachRecomendation[] = [];

    const baseDistanceMatrixUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric';
    const origins: String[] = availableCoachesWhoCoverActivity.map(coach => coach.baseEircode);
    const destinations: String = session.client.eircode;
    const apiKey = mapsApiKey.value();
    const distanceMatrixUrl = `${baseDistanceMatrixUrl}&origins=${origins.join('|')}&destinations=${destinations}&key=${apiKey}`;

    const response = await fetch(distanceMatrixUrl);
    const data = await response.json();

    const rows = data.rows;

    for (const row of rows) {
        const elements = row.elements;
        for (const element of elements) {
            const travelEstimate = new TravelEstimate({

                distance: element.distance.value,
                duration: element.duration.value * 1000,
            });
            const coach = availableCoachesWhoCoverActivity[rows.indexOf(row)];
            const coachTravelEstimate = new CoachTravelEstimate({
                travelEstimate,
                coach,
            });
            const qoutaInfo = await QoutaInfo.buildQoutaInfo([session], coachTravelEstimate);
            const coachRecommendation = new CoachRecomendation({
                coach,
                travelEstimate,
                qoutaInfo,
            });
            coachRecommendations.push(coachRecommendation);

        }
    }
    return coachRecommendations;


});










