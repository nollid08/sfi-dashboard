export class TravelEstimate {
    distance: number;
    duration: number;

    constructor({ distance, duration }: { distance: number, duration: number }) {
        this.distance = distance;
        this.duration = duration;
    }
}
