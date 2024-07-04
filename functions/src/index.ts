import { CallableRequest, onCall, } from "firebase-functions/v2/https";
const { initializeApp, } = require('firebase-admin/app');
const { getFirestore, } = require('firebase-admin/firestore');
import { defineSecret } from "firebase-functions/params"
import { Booking } from './models/booking';
import { Activity } from './models/activity';
import { ClientType } from "./models/client_type";
import { Client } from "./models/client";
import { TravelEstimate } from "./models/travel_estimate";
import { Coach } from "./models/coach";
import { BookingSession, BookingSessionData } from "./models/session";
import { CoachRecomendation } from "./models/coach_recommendation";
import { QoutaInfo } from "./models/qouta_info";
import { CoachTravelEstimate } from "./models/coach_travel_estimate";

initializeApp();
const mapsApiKey = defineSecret('MAPS_API_KEY');
export const find_coaches = onCall({ secrets: [mapsApiKey] }, async (request: CallableRequest) => {


    const bookingData = request.data.booking;
    const activity = new Activity(bookingData.activity.id, bookingData.activity.name, bookingData.activity.icon, bookingData.activity.color);
    const clientType = new ClientType(bookingData.client.type.id, bookingData.client.type.name);
    const client = new Client(bookingData.client.id, bookingData.client.name, bookingData.client.addressLineOne, bookingData.client.addressLineTwo, bookingData.client.eircode, bookingData.client.rollNumber, clientType,);
    const sessions: BookingSession[] = bookingData.sessions
        .map((session: {
            id: String;
            arrivalTime: string;
            leaveTime: string;
            startTime: string;
            endTime: string;
            coaches: String[];
        }) => new BookingSession({
            id: session.id,
            arrivalTime: new Date(session.arrivalTime),
            leaveTime: new Date(session.leaveTime),
            startTime: new Date(session.startTime),
            endTime: new Date(session.endTime),
            coaches: session.coaches,
            assignedCoaches: [],
        }));
    const booking = new Booking({
        id: bookingData.id,
        activity,
        sessions,
        client,
    });

    const db = getFirestore();

    const coachesWhoTeachRef = db.collection('users').where('activitiesCovered', 'array-contains', booking.activity.id);


    const coachesWhoCoverActivityDocs = await coachesWhoTeachRef.get();
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
    });

    // Filter for coaches who can cover the entire booking e.g don't have a session in db that overlaps with the new sessions
    const baseQuery = db.collection('sessions').where('coaches', 'array-contains-any', coachesWhoCoverActivity.map(coach => coach.uid));
    const busyCoachUids: String[] = [];
    for (let session of booking.sessions) {
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
                assignedCoaches: session.assignedCoaches,
            });
        });

        const coachUids = overlappingSessions.map(session => session.coaches).flat();

        for (let coachUid of coachUids) {
            if (!busyCoachUids.includes(coachUid)) {
                busyCoachUids.push(coachUid);
            }
        }
    }
    const availableCoachesWhoCoverActivity = coachesWhoCoverActivity.filter(coach => !busyCoachUids.includes(coach.uid));


    let coachRecommendations: CoachRecomendation[] = [];

    const baseDistanceMatrixUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric';
    const origins: String[] = availableCoachesWhoCoverActivity.map(coach => coach.baseEircode);
    const destinations: String = booking.client.eircode;
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
            const qoutaInfo = await QoutaInfo.buildQoutaInfo(booking.sessions, coachTravelEstimate);
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












