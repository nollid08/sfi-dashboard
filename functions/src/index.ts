import { firestore as fbTriggers } from "firebase-functions/v1";
import { find_bookings_available_coaches_function } from "./functions/find_bookings_available_coaches";
import { find_sessions_available_coaches_function } from "./functions/find_sessions_available_coaches";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { find_available_booking_options_function } from "./functions/find_available_booking_options";
import { getAuth } from "firebase-admin/auth";
import { defineString } from "firebase-functions/params";

const brevoApiKey = defineString("BREVO_API_KEY");

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

export const equipment_transfer_notification = fbTriggers
  .document("logs/{logId}")
  .onCreate(async (docSnapshot, context) => {
    const recipientUid: string = docSnapshot.data().recipientUid;
    const origineeUid: string = docSnapshot.data().origineeUid;
    const quantityTransferred: Number = docSnapshot.data().quantityTransferred;
    const equipmentId: string = docSnapshot.data().equipmentId;

    const auth = getAuth();
    const recipient = await auth.getUser(recipientUid);
    const originee = await auth.getUser(origineeUid);

    const db = getFirestore();
    const eqiupment = await db.collection("equipment").doc(equipmentId).get();

    console.log(
      `Equipment ${eqiupment?.data()?.name} has been transferred from ${
        originee.displayName
      } to ${recipient.displayName} with quantity ${quantityTransferred}`
    );
    // load from environment variables
    const url = "https://api.brevo.com/v3/smtp/email";

    console.log("Email Info:", recipient.email);
    const data = {
      to: [
        {
          email: recipient.email,
          name: recipient.displayName,
        },
      ],
      templateId: 796,
      params: {
        SENDER: originee.displayName,
        NAME: eqiupment?.data()?.name,
        QUANTITY: quantityTransferred.toString(),
      },

      headers: {
        "X-Mailin-custom":
          "custom_header_1:custom_value_1|custom_header_2:custom_value_2|custom_header_3:custom_value_3",
        charset: "iso-8859-1",
      },
    };

    const response = await fetch(url, {
      method: "POST",
      headers: {
        accept: "application/json",
        "content-type": "application/json",
        "api-key": brevoApiKey.value(),
      },
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(`Error: ${response.status} - ${errorData.message}`);
    }

    const result = await response.json();
    console.log("Email sent successfully:", result);
  });
