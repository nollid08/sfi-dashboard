import { Coach } from "./coach";
import { TravelInfo } from "./travel_info";

export class AssignedCoach {
    coach: Coach;
    travelInfo: TravelInfo;
    hasOvernighAllowance: boolean;

    constructor({ coach, travelInfo, hasOvernighAllowance }: { coach: Coach, travelInfo: TravelInfo, hasOvernighAllowance: boolean }) {
        this.coach = coach;
        this.travelInfo = travelInfo;
        this.hasOvernighAllowance = hasOvernighAllowance;
    }
}

export interface AssignedCoachData {
    coach: Coach;
    travelInfo: TravelInfo;
    hasOvernighAllowance: boolean;
}

