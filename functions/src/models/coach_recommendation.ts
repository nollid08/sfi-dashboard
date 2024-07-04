import { Coach } from "./coach";
import { TravelEstimate } from "./travel_estimate";
import { QoutaInfo } from "./qouta_info";

export class CoachRecomendation {
    coach: Coach;
    travelEstimate: TravelEstimate;
    qoutaInfo: QoutaInfo;

    constructor({ coach, travelEstimate, qoutaInfo }: { coach: Coach, travelEstimate: TravelEstimate, qoutaInfo: QoutaInfo }) {
        this.coach = coach;
        this.travelEstimate = travelEstimate;
        this.qoutaInfo = qoutaInfo;
    }
}