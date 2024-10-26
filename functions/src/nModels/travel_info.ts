export class TravelInfo {
    distance: number;
    duration: number;
    departureLocation: string;
    arrivalLocation: string;

    constructor({ distance, duration, departureLocation, arrivalLocation }: { distance: number, duration: number, departureLocation: string, arrivalLocation: string }) {
        this.distance = distance;
        this.duration = duration;
        this.departureLocation = departureLocation;
        this.arrivalLocation = arrivalLocation;
    }
}