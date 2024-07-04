import { Coach } from "./coach";
import { TravelEstimate } from "./travel_estimate";

export class CoachTravelEstimate {
    coach: Coach;
    travelEstimate: TravelEstimate;

    constructor({ coach, travelEstimate }: { coach: Coach, travelEstimate: TravelEstimate }) {
        this.coach = coach;
        this.travelEstimate = travelEstimate;
    }
}