import { RRule } from "rrule";
import { Client } from "./client";
import { ProvisionalSession } from "./provisional_session";

export class ProvisionalBooking {
  sessions: ProvisionalSession[];
  client: Client;

  constructor({
    sessions,
    client,
  }: {
    sessions: ProvisionalSession[];
    client: Client;
  }) {
    this.sessions = sessions;
    this.client = client;
  }

  static fromStartDate({
    startDate,
    client,
    halfTerm,
  }: {
    startDate: Date;
    client: Client;
    halfTerm: HalfTerm;
  }): ProvisionalBooking | null {
    const rRule = new RRule({
      freq: RRule.WEEKLY,
      dtstart: startDate,
      until: new Date(halfTerm.endDate),
    });
    let provisonalSessionsDays = rRule.all();

    let provisonalSessions: ProvisionalSession[] = provisonalSessionsDays.map(
      (date) =>
        ProvisionalSession.fromDate(
          date,
          new Date(client.startTime),
          new Date(client.endTime)
        )
    );
    if (provisonalSessions.length < 4) {
      return null;
    }
    if (provisonalSessions.length > 6) {
      provisonalSessions = provisonalSessions.slice(0, 6);
    }

    return new ProvisionalBooking({
      sessions: provisonalSessions,
      client,
    });
  }
}
