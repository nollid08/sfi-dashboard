import { RRule } from "rrule";
import { Activity } from "./activity";
import { Client } from "./client";

export class Booking {
    id: String;
    activity: Activity;
    initialArrival: Date;
    initialLeave: Date;
    initialActivityStart: Date;
    initialActivityEnd: Date;
    recurrenceRule?: RRule;
    client: Client;

    constructor({ id, activity, initialArrival, initialLeave, initialActivityStart, initialActivityEnd, recurrenceRule, client }: { id: String, activity: Activity, initialArrival: Date, initialLeave: Date, initialActivityStart: Date, initialActivityEnd: Date, recurrenceRule?: RRule, client: Client }) {
        this.id = id;
        this.activity = activity;
        this.initialArrival = initialArrival;
        this.initialLeave = initialLeave;
        this.initialActivityStart = initialArrival;
        this.initialActivityEnd = initialLeave;
        this.recurrenceRule = recurrenceRule;
        this.client = client;
    }

}