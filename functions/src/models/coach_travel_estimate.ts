import { Coach } from './coach';

export class CoachTravelEsimate {
    coach: Coach;
    distance: number;
    duration: number;

    constructor(coach: Coach, distance: number, duration: number) {
        this.coach = coach;
        this.distance = distance;
        this.duration = duration;
    }
}
