import { Activity } from "./activity";
import { Client } from "./client";
import { BookingSession } from "./session";

export class Booking {
  id: string;
  activity: Activity;
  sessions: BookingSession[];
  client: Client;

  constructor({
    id,
    activity,
    sessions,
    client,
  }: {
    id: string;
    activity: Activity;
    sessions: BookingSession[];
    client: Client;
  }) {
    this.id = id;
    this.activity = activity;
    this.sessions = sessions;
    this.client = client;
  }
}
