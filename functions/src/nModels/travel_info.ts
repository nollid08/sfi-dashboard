export class TravelInfo {
  outwardDistance: number; //km
  outwardDuration: number; //ms
  homewardDistance: number; //km
  homewardDuration: number; //ms
  departureLocation: string;
  arrivalLocation: string;

  constructor({
    outwardDistance,
    outwardDuration,
    homewardDistance,
    homewardDuration,
    departureLocation,
    arrivalLocation,
  }: {
    outwardDistance: number;
    outwardDuration: number;
    homewardDistance: number;
    homewardDuration: number;
    departureLocation: string;
    arrivalLocation: string;
  }) {
    this.outwardDistance = outwardDistance;
    this.outwardDuration = outwardDuration;
    this.homewardDistance = homewardDistance;
    this.homewardDuration = homewardDuration;
    this.departureLocation = departureLocation;
    this.arrivalLocation = arrivalLocation;
  }
}
