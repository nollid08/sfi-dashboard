import { firestore as fbTriggers } from "firebase-functions/v1";
import { find_bookings_available_coaches_function } from "./functions/find_bookings_available_coaches";
import { find_sessions_available_coaches_function } from "./functions/find_sessions_available_coaches";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { find_available_booking_options_function } from "./functions/find_available_booking_options";

initializeApp();

export const find_bookings_available_coaches =
  find_bookings_available_coaches_function;
export const find_sessions_available_coaches =
  find_sessions_available_coaches_function;
export const find_available_booking_options =
  find_available_booking_options_function;

export const normalise_client_data = fbTriggers
  .document("clients/{clientId}")
  .onUpdate((change, context) => {
    const newValue = change.after.data();

    //For each booking where the client ids match, update the client data
    const db = getFirestore();
    const bookingsRef = db.collection("bookings");
    const query = bookingsRef.where("client.id", "==", context.params.clientId);
    const p1 = query.get().then((querySnapshot) => {
      querySnapshot.forEach((doc) => {
        const booking = doc.data();
        booking.client = newValue;
        bookingsRef.doc(doc.id).set(booking);
      });
    });
    //For each session where the client ids match, update the client data
    const sessionsRef = db.collection("sessions");
    const query2 = sessionsRef.where(
      "client.id",
      "==",
      context.params.clientId
    );
    const q2 = query2.get().then((querySnapshot) => {
      querySnapshot.forEach((doc) => {
        const session = doc.data();
        session.client = newValue;
        sessionsRef.doc(doc.id).set(session);
      });
    });
    return Promise.all([p1, q2]);
  });
