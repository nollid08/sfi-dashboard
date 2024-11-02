import { firestore as fbTriggers } from "firebase-functions/v1";
import { getFirestore } from "firebase-admin/firestore";
import { TravelInfo } from "../models/travel_info";
import { defineSecret } from "firebase-functions/params";

const mapsApiKey = defineSecret("MAPS_API_KEY");

export const update_travel_info_function = fbTriggers
  .document("sessions/{sessionId}")
  .onUpdate(async (change, context) => {
    console.log("Updating travel info");
    const assignedCoaches = change.after.data().assignedCoaches;
    assignedCoaches.forEach(async (assignedCoach: any) => {
      const oldTravelInfo: TravelInfo = assignedCoach.travelInfo;
      const updatedTravelInfo: TravelInfo = assignedCoach.travelInfo;
      const clientEircode: string = change.after.data().client.eircode;

      if (oldTravelInfo === updatedTravelInfo) {
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
          outwardDuration: duration,
          homewardDistance: updatedTravelInfo.homewardDistance,
          homewardDuration: updatedTravelInfo.homewardDuration,
          departureLocation: updatedTravelInfo.departureLocation,
          arrivalLocation: updatedTravelInfo.arrivalLocation,
        });
        // Update the travel info in the session
        await db.collection("sessions").doc(context.params.sessionId).update({
          travelInfo: newTravelInfo,
        });
      }

      if (oldTravelInfo.arrivalLocation !== updatedTravelInfo.arrivalLocation) {
        const baseDistanceMatrixUrl =
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric";
        const origin: string = clientEircode;
        const destination: string = updatedTravelInfo.arrivalLocation;
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
          homewardDuration: duration,
          departureLocation: updatedTravelInfo.departureLocation,
          arrivalLocation: updatedTravelInfo.arrivalLocation,
        });
        // Update the travel info in the session
        await db.collection("sessions").doc(context.params.sessionId).update({
          travelInfo: newTravelInfo,
        });
      }
      return;
    });
  });
