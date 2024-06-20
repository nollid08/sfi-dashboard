import { CallableRequest, onCall, } from "firebase-functions/v2/https";
const { initializeApp, } = require('firebase-admin/app');
const { getFirestore, } = require('firebase-admin/firestore');
import { defineSecret } from "firebase-functions/params"

initializeApp();
const mapsApiKey = defineSecret('MAPS_API_KEY');
export const find_coaches = onCall({ secrets: [mapsApiKey] }, async (request: CallableRequest) => {


    const bookingData = request.data.booking;
    const activity = new Activity(bookingData.activity.id, bookingData.activity.name, bookingData.activity.icon, bookingData.activity.color);
    const clientType = new ClientType(bookingData.client.type.id, bookingData.client.type.name);
    const client = new Client(bookingData.client.id, bookingData.client.name, bookingData.client.addressLineOne, bookingData.client.addressLineTwo, bookingData.client.eircode, bookingData.client.rollNumber, clientType);


    const booking = new Booking(bookingData.id, activity, bookingData.startTime, bookingData.endTime, bookingData.recurrenceProperties, client);

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
        console.log(`${coach.name} has a base eircode - ${coach.baseEircode}`);
        return new Coach(doc.id, coach.name, coach.baseEircode, coach.activitiesCovered);
    });

    let coachTravelEstimates: CoachTravelEsimate[] = [];

    const baseDistanceMatrixUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric';
    const origins: String[] = coachesWhoCoverActivity.map(coach => coach.eircode);
    const destinations: String = booking.client.eircode;
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
        const leaveTime = new Date(booking.startTime);
        leaveTime.setSeconds(leaveTime.getSeconds() - duration);
        const coachTravelEstimate = new CoachTravelEsimate(coachesWhoCoverActivity[index], distance, duration, leaveTime.getTime());
        coachTravelEstimates.push(coachTravelEstimate);
    });

    return coachTravelEstimates;
});

class Booking {
    id: String;
    activity: Activity;
    startTime: Date;
    endTime: String; // "HH:MM"
    recurrenceProperties: String;
    client: Client;

    constructor(id: String, activity: Activity, startTime: Date, endTime: String, recurrenceProperties: String, client: Client) {
        this.id = id;
        this.activity = activity;
        this.startTime = startTime;
        this.endTime = endTime;
        this.recurrenceProperties = recurrenceProperties;
        this.client = client;
    }

    toString() {
        return `Booking: ${this.id}, ${this.activity}, ${this.startTime}, ${this.endTime}, ${this.recurrenceProperties}, ${this.client}`;
    }
}


class Client {
    id: String;
    name: String;
    addressLineOne: String;
    addressLineTwo: String;
    eircode: String;
    rollNumber: String;
    clientType: ClientType;


    constructor(id: String, name: String, addressLineOne: String, addressLineTwo: String, eircode: String, rollNumber: String, clientType: ClientType) {
        this.id = id;
        this.name = name;
        this.addressLineOne = addressLineOne;
        this.addressLineTwo = addressLineTwo;
        this.eircode = eircode;
        this.rollNumber = rollNumber;
        this.clientType = clientType;
    }

    toString() {
        return `Client: ${this.id}, ${this.name}, ${this.addressLineOne}, ${this.addressLineTwo}, ${this.eircode}, ${this.rollNumber}, ${this.clientType}`;
    }
}

class ClientType {
    id: String;
    name: String;

    constructor(id: String, name: String) {
        this.id = id;
        this.name = name;
    }

    toString() {
        return `ClientType: ${this.id}, ${this.name}`;
    }
}

class Activity {
    id: String;
    name: String;
    icon: String;
    color: String;

    constructor(id: String, name: String, icon: String, color: String) {
        this.id = id;
        this.name = name;
        this.icon = icon;
        this.color = color;
    }

    toString() {
        return `Activity: ${this.id}, ${this.name}, ${this.icon}, ${this.color}`;
    }
}

class Coach {
    uid: String;
    name: String;
    eircode: String;
    activitiesCovered: Array<String>;

    constructor(uid: String, name: String, eircode: String, activitiesCovered: Array<String>) {
        this.uid = uid;
        this.name = name;
        this.activitiesCovered = activitiesCovered;
        this.eircode = eircode;
    }
}

class CoachTravelEsimate {
    coach: Coach;
    distance: number;
    duration: number;
    leaveTime: number;

    constructor(coach: Coach, distance: number, duration: number, leaveTime: number) {
        this.coach = coach;
        this.distance = distance;
        this.duration = duration;
        this.leaveTime = leaveTime;
    }
}