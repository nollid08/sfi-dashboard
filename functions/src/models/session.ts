import { Timestamp } from "firebase-admin/firestore";
import { AssignedCoach } from "./assigned_coach";

export class BookingSession {
    id: String;
    arrivalTime: Date;
    startTime: Date;
    endTime: Date;
    leaveTime: Date;

    assignedCoaches: AssignedCoach[];
    coaches: String[];


    constructor({ id, arrivalTime, startTime, endTime, leaveTime, assignedCoaches, coaches }: { id: String, arrivalTime: Date, startTime: Date, endTime: Date, leaveTime: Date, assignedCoaches: AssignedCoach[], coaches: String[] }) {
        this.id = id;
        this.arrivalTime = arrivalTime;
        this.startTime = startTime;
        this.endTime = endTime;
        this.leaveTime = leaveTime;
        this.assignedCoaches = assignedCoaches;
        this.coaches = coaches;
    }

}

export interface BookingSessionData {
    id: String;
    arrivalTime: Timestamp;
    assignedCoaches: AssignedCoach[];
    leaveTime: Timestamp;
    startTime: Timestamp;
    endTime: Timestamp;
    coaches: String[];
}