import {
  DocumentData,
  FirestoreDataConverter,
  getFirestore,
  QueryDocumentSnapshot,
} from "firebase-admin/firestore";
import { Activity } from "./activity";
import { AssignedCoach } from "./assigned_coach";
import { Client } from "./client";
import { ProvisionalSession } from "./provisional_session";
import { CandidateCoach } from "./candidate_coach";

export class Session {
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

  static fromProvisionalSession(
    provisionalSession: ProvisionalSession,
    candidateCoach: CandidateCoach,
    client: Client,
    activity: Activity,
    departureLocation: string | undefined
  ): Session {
    return new Session({
      id: getFirestore().collection("sessions").doc().id,
      arrivalTime: provisionalSession.arrivalTime,
      startTime: provisionalSession.startTime,
      endTime: provisionalSession.endTime,
      leaveTime: provisionalSession.leaveTime,
      activity: activity,
      assignedCoaches: [
        AssignedCoach.fromCandidateCoach(
          candidateCoach,
          client,
          departureLocation
        ),
      ],
      coaches: [candidateCoach.coach.uid],
      client: client,
    });
  }

  serialise(): any {
    return {
      id: this.id,
      arrivalTime: this.arrivalTime.getTime(),
      startTime: this.startTime.getTime(),
      endTime: this.endTime.getTime(),
      leaveTime: this.leaveTime.getTime(),
      activity: this.activity,
      assignedCoaches: this.assignedCoaches,
      coaches: this.coaches,
      client: this.client,
    };
  }
}

export const sessionConverter: FirestoreDataConverter<Session> = {
  toFirestore(session: Session) {
    return {
      id: session.id,
      arrivalTime: session.arrivalTime,
      startTime: session.startTime,
      endTime: session.endTime,
      leaveTime: session.leaveTime,
      activity: session.activity,
      assignedCoaches: session.assignedCoaches,
      coaches: session.coaches,
      client: session.client,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot<DocumentData>): Session {
    const data = snapshot.data();
    return new Session({
      id: snapshot.id,
      arrivalTime: data.arrivalTime.toDate(),
      startTime: data.startTime.toDate(),
      endTime: data.endTime.toDate(),
      leaveTime: data.leaveTime.toDate,
      activity: data.activity,
      assignedCoaches: data.assignedCoaches,
      coaches: data.coaches,
      client: data.client,
    });
  },
};
