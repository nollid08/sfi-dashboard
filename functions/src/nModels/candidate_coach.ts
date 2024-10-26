import { Activity } from "./activity";
import { Client } from "./client";
import { Coach } from "./coach";
import { CoachTravelEstimate } from "./coach_travel_estimate";
import { FortnightlyQoutaPercentage } from "./fortnightly_qouta_info";
import { Session } from "./session";
import { TravelEstimate } from "./travel_estimate";

export class CandidateCoach {
  coach: Coach;
  travelEstimate: TravelEstimate;
  fortnightlyQoutaInfos: FortnightlyQoutaPercentage[];

  constructor({
    coach,
    travelEstimate,
    fortnightlyQoutaInfos,
  }: {
    coach: Coach;
    travelEstimate: TravelEstimate;
    fortnightlyQoutaInfos: FortnightlyQoutaPercentage[];
  }) {
    this.coach = coach;
    this.travelEstimate = travelEstimate;
    this.fortnightlyQoutaInfos = fortnightlyQoutaInfos;
  }

  isSuitable(activity: Activity): boolean {
    return this.coach.activitiesCovered.includes(activity.id);
  }

  calculateCoachScore(): number {
    //Constant modifiers for the score calculation
    const travelTimeFactor = 1.7;
    const skillFactor = 1;
    const contractFillledPercentage = 0.7;

    const skill = 1;
    const averageContractFilledPercentage =
      this.fortnightlyQoutaInfos.reduce(
        (acc, fortnightlyQoutaInfo) =>
          acc + fortnightlyQoutaInfo.qoutaPercentage,
        0
      ) / this.fortnightlyQoutaInfos.length;
    const travelTimeMinutes = this.travelEstimate.duration / 60000;

    const travelTimeSaved = 120 - travelTimeMinutes;
    const contractToFill = 100 - averageContractFilledPercentage;

    const score =
      skill * skillFactor +
      travelTimeSaved * travelTimeFactor +
      contractToFill * contractFillledPercentage;
    return score;
  }

  static async buildCandidateCoaches(
    coaches: Coach[],
    client: Client,
    allSessions: Session[],
    mapsApiKey: string
  ): Promise<CandidateCoach[]> {
    const CoachesTravelEstimates =
      await CoachTravelEstimate.BuildCoachesTravelEstimates(
        coaches,
        client,
        mapsApiKey
      );

    const candidateCoaches: CandidateCoach[] = CoachesTravelEstimates.map(
      (coachTravelEstimate) => {
        const fortnightlyQoutaInfos: FortnightlyQoutaPercentage[] =
          FortnightlyQoutaPercentage.calculateCoachsFortnightlyQoutaPercentages(
            coachTravelEstimate.coach,
            allSessions
          );

        return new CandidateCoach({
          coach: coachTravelEstimate.coach,
          travelEstimate: coachTravelEstimate.travelEstimate,
          fortnightlyQoutaInfos: fortnightlyQoutaInfos,
        });
      }
    ).filter(
      (candidateCoach) => candidateCoach.travelEstimate.duration <= 7200000
    );
    return candidateCoaches;
  }
}
