import { CallableRequest, onCall, } from "firebase-functions/v2/https";
const { initializeApp, } = require('firebase-admin/app');
const { getFirestore, } = require('firebase-admin/firestore');

initializeApp();

export const find_coaches = onCall(async (request: CallableRequest) => {


    const bookingData = request.data.booking;
    const activity = new Activity(bookingData.activity.id, bookingData.activity.name, bookingData.activity.icon, bookingData.activity.color);
    const clientType = new ClientType(bookingData.client.type.id, bookingData.client.type.name);
    const client = new Client(bookingData.client.id, bookingData.client.name, bookingData.client.addressLineOne, bookingData.client.addressLineTwo, bookingData.client.eircode, bookingData.client.rollNumber, clientType);


    const booking = new Booking(bookingData.id, activity, bookingData.startTime, bookingData.endTime, bookingData.recurrenceProperties, client);

    const db = getFirestore();

    const coachesWhoTeachRef = db.collection('users').where('activitiesCovered', 'array-contains', booking.activity.id);

    let suitableCoaches: Coach[] = [];

    const coachesWhoTeach = await coachesWhoTeachRef.get();
    console.log('coachesWhoTeach', coachesWhoTeach.docs.length);
    if (coachesWhoTeach.empty) {
        console.log('No matching documents.');
        return [];
    }

    coachesWhoTeach.forEach((doc: any) => {
        const coach = doc.data();
        const suitableCoach = new Coach(doc.id, coach.name, coach.activitiesCovered);
        suitableCoaches.push(suitableCoach);
    });



    return suitableCoaches;
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
    eircode: String = 'p67RC92';
    activitiesCovered: Array<String>;

    constructor(id: String, name: String, activitiesCovered: Array<String>,) {
        this.uid = id;
        this.name = name;
        this.activitiesCovered = activitiesCovered;
    }
}