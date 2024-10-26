import { Client } from "./client";
import { Coach } from "./coach";
import { TravelEstimate } from "./travel_estimate";

export class CoachTravelEstimate {
  coach: Coach;
  travelEstimate: TravelEstimate;

  constructor({
    coach,
    travelEstimate,
  }: {
    coach: Coach;
    travelEstimate: TravelEstimate;
  }) {
    this.coach = coach;
    this.travelEstimate = travelEstimate;
  }

  static async BuildCoachesTravelEstimates(
    coaches: Coach[],
    client: Client,
    mapsApiKey: string
  ): Promise<CoachTravelEstimate[]> {
    const baseDistanceMatrixUrl =
      "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric";
    const origins: string[] = coaches.map((coach) => coach.baseEircode);
    const destinations: string = client.eircode;
    const distanceMatrixUrl = `${baseDistanceMatrixUrl}&origins=${origins.join(
      "|"
    )}&destinations=${destinations}&key=${mapsApiKey}`;

    const response = await fetch(distanceMatrixUrl);
    const data = await response.json();

    const rows = data.rows;

    const coachesTravelEstimates: CoachTravelEstimate[] = rows.map(
      (row: any, index: number) => {
        const travelEstimate = new TravelEstimate({
          distance: row.elements[0].distance.value,
          duration: row.elements[0].duration.value * 1000,
        });
        const coach = coaches[index];
        console.log(
          "Coach",
          coach.name,
          "TravelEstimate",
          travelEstimate.duration / 60 / 60
        );
        return new CoachTravelEstimate({
          travelEstimate,
          coach,
        });
      }
    );

    return coachesTravelEstimates;
  }
}
