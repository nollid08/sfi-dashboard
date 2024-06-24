import { CallableRequest, onCall, } from "firebase-functions/v2/https";
const { initializeApp, } = require('firebase-admin/app');
const { getFirestore, } = require('firebase-admin/firestore');
import { defineSecret } from "firebase-functions/params"
import { RRule, } from 'rrule';
import { Booking } from './models/booking';
import { Activity } from './models/activity';
import { ClientType } from "./models/client_type";
import { Client } from "./models/client";
import { CoachTravelEsimate as CoachTravelEstimate } from "./models/coach_travel_estimate";
import { Coach } from "./models/coach";

initializeApp();
const mapsApiKey = defineSecret('MAPS_API_KEY');
export const find_coaches = onCall({ secrets: [mapsApiKey] }, async (request: CallableRequest) => {


    const bookingData = request.data.booking;
    const activity = new Activity(bookingData.activity.id, bookingData.activity.name, bookingData.activity.icon, bookingData.activity.color);
    const clientType = new ClientType(bookingData.client.type.id, bookingData.client.type.name);
    const client = new Client(bookingData.client.id, bookingData.client.name, bookingData.client.addressLineOne, bookingData.client.addressLineTwo, bookingData.client.eircode, bookingData.client.rollNumber, clientType,);
    console.log('BookingData', bookingData);
    const recurrenceRule = !!bookingData.recurrenceProperties ? undefined : RRule.fromString(bookingData.recurrenceProperties);
    const fgh = new Booking({
        id: bookingData.id,
        activity: activity,
        initialArrival: new Date(bookingData.initialArrival),
        initialLeave: new Date(bookingData.initialLeave),
        initialActivityStart: new Date(bookingData.initialActivityStart),
        initialActivityEnd: new Date(bookingData.initialActivityEnd),
        recurrenceRule: recurrenceRule,
        client: client
    });

    const db = getFirestore();

    const coachesWhoTeachRef = db.collection('users').where('activitiesCovered', 'array-contains', fgh.activity.id);


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
        console.log(`${coach.name} has a base eircode - ${coach.baseEircode}`);
        return new Coach(doc.id, coach.name, coach.baseEircode, coach.activitiesCovered);
    });

    let coachTravelEstimates: CoachTravelEstimate[] = [];

    const baseDistanceMatrixUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric';
    const origins: String[] = coachesWhoCoverActivity.map(coach => coach.eircode);
    const destinations: String = fgh.client.eircode;
    const apiKey = mapsApiKey.value();
    const distanceMatrixUrl = `${baseDistanceMatrixUrl}&origins=${origins.join('|')}&destinations=${destinations}&key=${apiKey}`;

    const response = await fetch(distanceMatrixUrl);
    const data = await response.json();
    console.log('data', data);

    const rows = data.rows;
    console.log('rows', rows);

    rows.forEach((row: any, index: number) => {
        const elements = row.elements;
        console.log('elements', elements);
        const element = elements[0];
        console.log('element', element);
        const distance = element.distance.value;
        const duration = element.duration.value;
        const coachTravelEstimate = new CoachTravelEstimate(coachesWhoCoverActivity[index], distance, duration);
        coachTravelEstimates.push(coachTravelEstimate);
    });

    return coachTravelEstimates;
});












