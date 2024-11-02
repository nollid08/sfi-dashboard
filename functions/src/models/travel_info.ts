export class TravelInfo {
  outwardDistance: number;
  outwardDuration: number;
  homewardDistance: number;
  homewardDuration: number;
  departureLocation: string;
  returnLocation: string;

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
    this.returnLocation = arrivalLocation;
  }
}
