import { Timestamp } from "firebase-admin/firestore";
import { AssignedCoach } from "./assigned_coach";
import { Activity, ActivityData } from "./activity";
import { Client, ClientData } from "./client";

export class BookingSession {
  id: string;
  arrivalTime: Date;
  startTime: Date;
  endTime: Date;
  leaveTime: Date;
  activity: Activity;
  assignedCoaches: AssignedCoach[];
  coaches: string[];
  client: Client;

  constructor({
    id,
    arrivalTime,
    startTime,
    endTime,
    leaveTime,
    activity,
    assignedCoaches,
    coaches,
    client,
  }: {
    id: string;
    arrivalTime: Date;
    startTime: Date;
    endTime: Date;
    leaveTime: Date;
    activity: Activity;
    assignedCoaches: AssignedCoach[];
    coaches: string[];
    client: Client;
  }) {
    this.id = id;
    this.arrivalTime = arrivalTime;
    this.startTime = startTime;
    this.endTime = endTime;
    this.leaveTime = leaveTime;
    this.activity = activity;
    this.assignedCoaches = assignedCoaches;
    this.coaches = coaches;
    this.client = client;
  }
}

export interface BookingSessionData {
  id: string;
  arrivalTime: Timestamp;
  assignedCoaches: AssignedCoach[];
  leaveTime: Timestamp;
  startTime: Timestamp;
  endTime: Timestamp;
  coaches: string[];
  activity: ActivityData;
  client: ClientData;
}
