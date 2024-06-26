import { CallableRequest, onCall, } from "firebase-functions/v2/https";
const { initializeApp, } = require('firebase-admin/app');
const { getFirestore, } = require('firebase-admin/firestore');
import { defineSecret } from "firebase-functions/params"
import { Booking } from './models/booking';
import { Activity } from './models/activity';
import { ClientType } from "./models/client_type";
import { Client } from "./models/client";
import { CoachTravelEsimate as CoachTravelEstimate } from "./models/coach_travel_estimate";
import { Coach } from "./models/coach";
import { BookingSession, BookingSessionData } from "./models/session";

initializeApp();
const mapsApiKey = defineSecret('MAPS_API_KEY');
export const find_coaches = onCall({ secrets: [mapsApiKey] }, async (request: CallableRequest) => {


    const bookingData = request.data.booking;
    const activity = new Activity(bookingData.activity.id, bookingData.activity.name, bookingData.activity.icon, bookingData.activity.color);
    const clientType = new ClientType(bookingData.client.type.id, bookingData.client.type.name);
    const client = new Client(bookingData.client.id, bookingData.client.name, bookingData.client.addressLineOne, bookingData.client.addressLineTwo, bookingData.client.eircode, bookingData.client.rollNumber, clientType,);
    const sessions: BookingSession[] = bookingData.sessions
        .map((session: BookingSessionData) => new BookingSession({
            id: session.id,
            arrivalTime: new Date(session.arrivalTime),
            leaveTime: new Date(session.leaveTime),
            startTime: new Date(session.startTime),
            endTime: new Date(session.endTime),
            coaches: session.coaches,
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
    console.log('coachesWhoTeach', coachesWhoCoverActivityDocs.docs.length);
    if (coachesWhoCoverActivityDocs.empty) {
        console.log('No Coaches Found');
        return [];
    }


    const coachesWhoCoverActivity: Coach[] = coachesWhoCoverActivityDocs.docs.map((doc: any) => {
        const coach = doc.data();
        if (coach.baseEircode == undefined) {
            console.log(`${coach.name} does not have a base eircode`);
            return;
        }
        return new Coach(doc.id, coach.name, coach.baseEircode, coach.activitiesCovered);
    });

    // Filter for coaches who can cover the entire booking e.g don't have a session in db that overlaps with the new sessions
    const baseQuery = db.collection('sessions').where('coaches', 'array-contains-any', coachesWhoCoverActivity.map(coach => coach.uid));
    const busyCoachUids: String[] = [];
    for (let session of booking.sessions) {
        console.log('session', session.arrivalTime.toDateString());
        const fullOverlapSession = await baseQuery.where('arrivalTime', '<=', session.arrivalTime).where('leaveTime', '>=', session.leaveTime).get();
        const beginningOverlapSession = await baseQuery.where('arrivalTime', '>=', session.arrivalTime).where('arrivalTime', '<=', session.leaveTime).get();
        const endOverlapSession = await baseQuery.where('leaveTime', '>=', session.arrivalTime).where('leaveTime', '<=', session.leaveTime).get();
        const overlappingSessionDocs = fullOverlapSession.docs.concat(beginningOverlapSession.docs).concat(endOverlapSession.docs);
        const overlappingSessions: BookingSession[] = overlappingSessionDocs.map((doc: any) => {
            const session: BookingSessionData = doc.data();
            return new BookingSession({
                id: doc.id,
                arrivalTime: session.arrivalTime,
                leaveTime: session.leaveTime,
                startTime: session.startTime,
                endTime: session.endTime,
                coaches: session.coaches,
            });
        });

        const coachUids = overlappingSessions.map(session => session.coaches).flat();

        for (let coachUid of coachUids) {
            if (!busyCoachUids.includes(coachUid)) {
                busyCoachUids.push(coachUid);
            }
        }
    }
    console.log('busyCoachUids', busyCoachUids);
    const availableCoachesWhoCoverActivity = coachesWhoCoverActivity.filter(coach => !busyCoachUids.includes(coach.uid));
    console.log('availableCoachesWhoCoverActivity', availableCoachesWhoCoverActivity);


    let coachTravelEstimates: CoachTravelEstimate[] = [];

    const baseDistanceMatrixUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric';
    const origins: String[] = availableCoachesWhoCoverActivity.map(coach => coach.eircode);
    const destinations: String = booking.client.eircode;
    const apiKey = mapsApiKey.value();
    const distanceMatrixUrl = `${baseDistanceMatrixUrl}&origins=${origins.join('|')}&destinations=${destinations}&key=${apiKey}`;

    const response = await fetch(distanceMatrixUrl);
    const data = await response.json();

    const rows = data.rows;

    rows.forEach((row: any, index: number) => {
        const elements = row.elements;
        const element = elements[0];
        const distance = element.distance.value;
        const duration = element.duration.value;
        const coachTravelEstimate = new CoachTravelEstimate(availableCoachesWhoCoverActivity[index], distance, duration);
        coachTravelEstimates.push(coachTravelEstimate);
    });

    return coachTravelEstimates;
});












