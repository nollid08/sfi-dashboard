import { Activity } from "./activity";
import { Client } from "./client";
import { BookingSession } from "./session";

export class Booking {
    id: String;
    activity: Activity;
    sessions: BookingSession[];
    client: Client;


    constructor({ id, activity, sessions, client, }: { id: String, activity: Activity, sessions: BookingSession[], client: Client, }) {
        this.id = id;
        this.activity = activity;
        this.sessions = sessions;
        this.client = client;
    }

}