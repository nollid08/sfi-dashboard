import { getFirestore } from "firebase-admin/firestore";
import { Activity } from "./activity";
import { CandidateCoach } from "./candidate_coach";
import { Client } from "./client";
import { ProvisionalBooking } from "./provisional_booking";
import { Session } from "./session";

export class RecommendedBooking {
  id: string;
  activity: Activity;
  sessions: Session[];
  client: Client;
  score: number;

  constructor({
    id,
    activity,
    sessions,
    client,
    score,
  }: {
    id: string;
    activity: Activity;
    sessions: Session[];
    client: Client;
    score: number;
  }) {
    this.id = id;
    this.activity = activity;
    this.sessions = sessions;
    this.client = client;
    this.score = score;
  }

  static fromProvisionalBooking(
    provisionalBooking: ProvisionalBooking,
    activity: Activity,
    candidateCoach: CandidateCoach,
    departureLocation: string | undefined
  ): RecommendedBooking {
    const sessions: Session[] = provisionalBooking.sessions.map(
      (provisionalSession) =>
        Session.fromProvisionalSession(
          provisionalSession,
          candidateCoach,
          provisionalBooking.client,
          activity,
          departureLocation
        )
    );
    return new RecommendedBooking({
      id: getFirestore().collection("bookings").doc().id,
      activity,
      sessions,
      client: provisionalBooking.client,
      score: candidateCoach.calculateCoachScore(),
    });
  }

  //Serialise the booking - convert all dates to ms since epoch
  serialise(): any {
    return {
      id: this.id,
      activity: this.activity,
      sessions: this.sessions.map((session) => session.serialise()),
      client: this.client,
      score: this.score,
    };
  }
}
