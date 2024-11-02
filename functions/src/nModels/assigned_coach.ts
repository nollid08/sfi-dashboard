import { CandidateCoach } from "./candidate_coach";
import { Client } from "./client";
import { Coach } from "./coach";
import { TravelInfo } from "./travel_info";

export class AssignedCoach {
  coach: Coach;
  travelInfo: TravelInfo;
  hasOvernighAllowance: boolean;

  constructor({
    coach,
    travelInfo,
    hasOvernighAllowance,
  }: {
    coach: Coach;
    travelInfo: TravelInfo;
    hasOvernighAllowance: boolean;
  }) {
    this.coach = coach;
    this.travelInfo = travelInfo;
    this.hasOvernighAllowance = hasOvernighAllowance;
  }

  static fromCandidateCoach(
    candidateCoach: CandidateCoach,
    client: Client,
    departureLocation: string | undefined
  ): AssignedCoach {
    return new AssignedCoach({
      coach: candidateCoach.coach,
      travelInfo: new TravelInfo({
        outwardDistance: candidateCoach.travelEstimate.distance,
        outwardDuration: candidateCoach.travelEstimate.duration,
        homewardDistance: candidateCoach.travelEstimate.distance,
        homewardDuration: candidateCoach.travelEstimate.duration,
        departureLocation:
          departureLocation ?? candidateCoach.coach.baseEircode,
        arrivalLocation: client.eircode,
      }),
      hasOvernighAllowance: false,
    });
  }
}
