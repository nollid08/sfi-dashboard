import { getFirestore } from "firebase-admin/firestore";
import { TravelInfo } from "../models/travel_info";
import { defineSecret } from "firebase-functions/params";
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { AssignedCoach } from "../models/assigned_coach";

const mapsApiKey = defineSecret("MAPS_API_KEY");

export const update_travel_info_function = onDocumentWritten(
  {
    document: "sessions/{sessionId}",
    secrets: [mapsApiKey],
  },
  async (event) => {
    if (!event.data || !event.data.after.exists || !event.data.before.exists) {
      console.log("Session deleted");
      return null;
    }

    console.log("Updating travel info");
    const assignedCoaches: AssignedCoach[] =
      event.data.after.data()!.assignedCoaches;
    assignedCoaches.forEach(async (assignedCoach: AssignedCoach) => {
      const oldTravelInfo: TravelInfo = event
        .data!.before.data()!
        .assignedCoaches.find(
          (coach: AssignedCoach) => coach.coach.uid === assignedCoach.coach.uid
        ).travelInfo;
      const updatedTravelInfo: TravelInfo = assignedCoach.travelInfo;
      const clientEircode: string = event.data!.after.data()!.client.eircode;

      if (
        oldTravelInfo.departureLocation ===
          updatedTravelInfo.departureLocation &&
        oldTravelInfo.returnLocation === updatedTravelInfo.returnLocation
      ) {
        console.log("No travel info changes detected");
        return null;
      }

      const db = getFirestore();
      if (
        oldTravelInfo.departureLocation !== updatedTravelInfo.departureLocation
      ) {
        const baseDistanceMatrixUrl =
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric";
        const origin: string = updatedTravelInfo.departureLocation;
        const destination: string = clientEircode;
        const apiKey = mapsApiKey.value();
        const distanceMatrixUrl = `${baseDistanceMatrixUrl}&origins=${origin}
      )}&destinations=${destination}&key=${apiKey}`;

        const response = await fetch(distanceMatrixUrl);
        const data = await response.json();

        const rows = data.rows;
        const elements = rows[0].elements;
        const distance = elements[0].distance.value;
        const duration = elements[0].duration.value;
        const newTravelInfo = new TravelInfo({
          outwardDistance: distance,
          outwardDuration: duration * 1000,
          homewardDistance: updatedTravelInfo.homewardDistance,
          homewardDuration: updatedTravelInfo.homewardDuration,
          departureLocation: updatedTravelInfo.departureLocation,
          arrivalLocation: updatedTravelInfo.returnLocation,
        });
        console.log("Outward distance: ", distance);
        console.log("Outward duration: ", duration);
        // Update the assigned coaches travel info with the new distance and duration values for the outward journey in the session
        const tiJson = JSON.parse(JSON.stringify(newTravelInfo));
        await db
          .collection("sessions")
          .doc(event.params.sessionId)
          .update({
            assignedCoaches: assignedCoaches.map((coach: any) => {
              if (coach.coach.uid === assignedCoach.coach.uid) {
                return {
                  ...coach,
                  travelInfo: tiJson,
                };
              }
              return coach;
            }),
          });
      }

      if (oldTravelInfo.returnLocation !== updatedTravelInfo.returnLocation) {
        const baseDistanceMatrixUrl =
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric";
        const origin: string = clientEircode;
        const destination: string = updatedTravelInfo.returnLocation;
        const apiKey = mapsApiKey.value();
        const distanceMatrixUrl = `${baseDistanceMatrixUrl}&origins=${origin}&destinations=${destination}&key=${apiKey}`;

        const response = await fetch(distanceMatrixUrl);
        const data = await response.json();

        const rows = data.rows;
        const elements = rows[0].elements;
        const distance = elements[0].distance.value;
        const duration = elements[0].duration.value;
        const newTravelInfo = new TravelInfo({
          outwardDistance: updatedTravelInfo.outwardDistance,
          outwardDuration: updatedTravelInfo.outwardDuration,
          homewardDistance: distance,
          homewardDuration: duration * 1000,
          departureLocation: updatedTravelInfo.departureLocation,
          arrivalLocation: updatedTravelInfo.returnLocation,
        });

        console.log("Homeward distance: ", distance);
        console.log("Homeward duration: ", duration);
        // Update the assigned coaches travel info with the new distance and duration values for the outward journey in the session
        const tiJson = JSON.parse(JSON.stringify(newTravelInfo));
        await db
          .collection("sessions")
          .doc(event.params.sessionId)
          .update({
            assignedCoaches: assignedCoaches.map((coach: any) => {
              if (coach.coach.uid === assignedCoach.coach.uid) {
                return {
                  ...coach,
                  travelInfo: tiJson,
                };
              }
              return coach;
            }),
          });
      }
      return;
    });
    return;
  }
);
