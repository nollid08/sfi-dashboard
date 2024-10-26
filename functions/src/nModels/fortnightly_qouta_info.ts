import { Coach } from "./coach";
import { Fortnight } from "./fortnight";
import { Session } from "./session";

export class FortnightlyQoutaPercentage {
  fortnight: Fortnight;
  qoutaPercentage: number;

  constructor({
    fortnight,
    qoutaPercentage: currentQoutaPercentage,
  }: {
    fortnight: Fortnight;
    qoutaPercentage: number;
  }) {
    this.fortnight = fortnight;
    this.qoutaPercentage = currentQoutaPercentage;
  }

  static calculateCoachsFortnightlyQoutaPercentages(
    coach: Coach,
    allSessions: Session[]
  ) {
    const coachesSessions = allSessions.filter((session) =>
      session.coaches.includes(coach.uid)
    );

    const startDate = new Date(allSessions[0].startTime);
    const endDate = new Date(allSessions[allSessions.length - 1].endTime);
    const currentCoachQouta = coach.timeToCover;
    const fortnights = Fortnight.fromRange(startDate, endDate);
    const fortnightlyQoutaPercentages = fortnights.map((fortnight) => {
      const sessionsInFortnight = coachesSessions.filter(
        (session) =>
          session.arrivalTime >= fortnight.startDate &&
          session.endTime <= fortnight.endDate
      );
      let timeCoveredInFortnight = sessionsInFortnight.reduce(
        (acc, session) => {
          if (session == undefined) {
            return acc;
          }
          console.log("SessionTY", session.id);
          const totalsessionTime =
            session.endTime.getTime() - session.startTime.getTime();
          const overallTravelInfo = session.assignedCoaches.filter(
            (assignedCoach) => assignedCoach.coach.uid == coach.uid
          )[0].travelInfo;
          const OverallTravelTime = overallTravelInfo.duration * 2;
          let coveredTravelTime =
            OverallTravelTime >= 14400000
              ? OverallTravelTime
              : OverallTravelTime - 3600000;
          if (coveredTravelTime < 0) {
            coveredTravelTime = 0;
          }
          const timeCovered = totalsessionTime + coveredTravelTime;
          return acc + timeCovered;
        },
        0
      );

      const actualPercentageCovered =
        timeCoveredInFortnight / currentCoachQouta;
      return new FortnightlyQoutaPercentage({
        fortnight,
        qoutaPercentage: actualPercentageCovered,
      });
    });
    return fortnightlyQoutaPercentages;
  }
}
