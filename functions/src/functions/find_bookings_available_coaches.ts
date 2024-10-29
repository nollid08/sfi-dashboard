import { getFirestore } from "firebase-admin/firestore";
import { onCall, CallableRequest } from "firebase-functions/v2/https";
import { Activity, ActivityData } from "../models/activity";
import { Booking } from "../models/booking";
import { Client } from "../models/client";
import { ClientType } from "../models/client_type";
import { Coach } from "../models/coach";
import { CoachRecomendation } from "../models/coach_recommendation";
import { CoachTravelEstimate } from "../models/coach_travel_estimate";
import { QoutaInfo } from "../models/qouta_info";
import { BookingSession, BookingSessionData } from "../models/session";
import { TravelEstimate } from "../models/travel_estimate";
import { defineSecret } from "firebase-functions/params";
import { Leave, LeaveStatus } from "../models/leave";

const mapsApiKey = defineSecret("MAPS_API_KEY");
export const find_bookings_available_coaches_function = onCall(
  { secrets: [mapsApiKey] },
  async (request: CallableRequest) => {
    const bookingData = request.data.booking;
    const activity = new Activity(
      bookingData.activity.id,
      bookingData.activity.name,
      bookingData.activity.icon,
      bookingData.activity.color
    );
    const clientType = new ClientType(
      bookingData.client.type.id,
      bookingData.client.type.name
    );
    const client = new Client({
      id: bookingData.client.id,
      name: bookingData.client.name,
      addressLineOne: bookingData.client.addressLineOne,
      addressLineTwo: bookingData.client.addressLineTwo,
      eircode: bookingData.client.eircode,
      rollNumber: bookingData.client.rollNumber,
      clientType,
    });
    const sessions: BookingSession[] = bookingData.sessions.map(
      (session: {
        id: string;
        arrivalTime: string;
        leaveTime: string;
        startTime: string;
        endTime: string;
        activity: ActivityData;
        coaches: string[];
      }) =>
        new BookingSession({
          id: session.id,
          arrivalTime: new Date(session.arrivalTime),
          leaveTime: new Date(session.leaveTime),
          startTime: new Date(session.startTime),
          endTime: new Date(session.endTime),
          activity: new Activity(
            session.activity.id,
            session.activity.name,
            session.activity.icon,
            session.activity.color
          ),
          assignedCoaches: [],
          coaches: session.coaches,
          client,
        })
    );
    const booking = new Booking({
      id: bookingData.id,
      activity,
      sessions,
      client,
    });

    const db = getFirestore();

    const coachesWhoTeachRef = db
      .collection("users")
      .where("activitiesCovered", "array-contains", booking.activity.id);

    const coachesWhoCoverActivityDocs = await coachesWhoTeachRef.get();
    if (coachesWhoCoverActivityDocs.empty) {
      console.log("No Coaches Found");
      return [];
    }

    const coachesWhoCoverActivity: Coach[] = coachesWhoCoverActivityDocs.docs
      .map((doc: any) => {
        const coach = doc.data();
        if (
          coach.baseEircode == undefined ||
          coach.baseEircode == "" ||
          coach.timeToCover == undefined ||
          coach.timeToCover == 0
        ) {
          console.log(`${coach.name} does not have a base eircode`);
          return;
        } else {
          console.log(
            `${coach.name} has a base eircode - ${coach.baseEircode}`
          );
        }
        return new Coach({
          uid: doc.id,
          name: coach.name,
          baseEircode: coach.baseEircode,
          activitiesCovered: coach.activitiesCovered,
          timeToCover: coach.timeToCover,
        });
      })
      .filter(
        (coach: Coach | undefined): coach is Coach => coach !== undefined
      );

    // Filter for coaches who can cover the entire booking e.g don't have a session in db that overlaps with the new sessions
    const baseQuery = db.collection("sessions").where(
      "coaches",
      "array-contains-any",
      coachesWhoCoverActivity.map((coach) => coach.uid)
    );
    const workingCoachUids: string[] = [];
    for (let session of booking.sessions) {
      const fullOverlapSession = await baseQuery
        .where("arrivalTime", "<=", session.arrivalTime)
        .where("leaveTime", ">=", session.endTime)
        .get();
      const beginningOverlapSession = await baseQuery
        .where("arrivalTime", ">=", session.arrivalTime)
        .where("arrivalTime", "<=", session.endTime)
        .get();
      const endOverlapSession = await baseQuery
        .where("leaveTime", ">=", session.arrivalTime)
        .where("leaveTime", "<=", session.endTime)
        .get();
      const overlappingSessionDocs = fullOverlapSession.docs
        .concat(beginningOverlapSession.docs)
        .concat(endOverlapSession.docs);
      const overlappingSessions: BookingSession[] = overlappingSessionDocs.map(
        (doc: any) => {
          const session: BookingSessionData = doc.data();

          return new BookingSession({
            id: doc.id,
            arrivalTime: session.arrivalTime.toDate(),
            leaveTime: session.leaveTime.toDate(),
            startTime: session.startTime.toDate(),
            endTime: session.endTime.toDate(),
            coaches: session.coaches,
            activity: new Activity(
              session.activity.id,
              session.activity.name,
              session.activity.icon,
              session.activity.color
            ),
            client: new Client({
              id: session.client.id,
              name: session.client.name,
              addressLineOne: session.client.addressLineOne,
              addressLineTwo: session.client.addressLineTwo,
              eircode: session.client.eircode,
              rollNumber: session.client.rollNumber,
              clientType: new ClientType(
                session.client.type.id,
                session.client.type.name
              ),
            }),
            assignedCoaches: session.assignedCoaches,
          });
        }
      );

      const coachUids = overlappingSessions
        .map((session) => session.coaches)
        .flat();

      for (let coachUid of coachUids) {
        if (!workingCoachUids.includes(coachUid)) {
          workingCoachUids.push(coachUid);
        }
      }
    }
    const notWorkingCoachesWhoCoverActivity = coachesWhoCoverActivity.filter(
      (coach) => !workingCoachUids.includes(coach.uid)
    );

    // Fliter for coaches who are on leave during any of the sessions
    const leaveRef = db.collection("leaves");
    const leaveQuery = leaveRef.where(
      "coachUid",
      "in",
      notWorkingCoachesWhoCoverActivity.map((coach) => coach.uid)
    );
    const leaveDocs = await leaveQuery.get();
    const leaves: Leave[] = leaveDocs.docs.map((doc: any) => {
      const leave = doc.data();
      return {
        id: doc.id,
        coachUid: leave.coachUid,
        startDate: leave.startDate.toDate(),
        endDate: leave.endDate.toDate(),
        type: leave.type,
        status: leave.status,
      };
    });
    const applicableLeaves: Leave[] = leaves.filter((leave) => {
      if (leave.status === LeaveStatus.rejected) {
        return false;
      }
      return true;
    });
    //Now check each session against the leaves
    const onLeaveCoaches: Coach[] = [];
    for (let session of booking.sessions) {
      for (let leave of applicableLeaves) {
        if (
          session.startTime >= leave.startDate &&
          session.endTime <= leave.endDate
        ) {
          if (
            !onLeaveCoaches.map((coach) => coach.uid).includes(leave.coachUid)
          ) {
            onLeaveCoaches.push(
              notWorkingCoachesWhoCoverActivity.find(
                (coach) => coach.uid === leave.coachUid
              )!
            );
          }
        }
        if (
          session.startTime <= leave.startDate &&
          session.endTime >= leave.startDate
        ) {
          if (
            !onLeaveCoaches.map((coach) => coach.uid).includes(leave.coachUid)
          ) {
            onLeaveCoaches.push(
              notWorkingCoachesWhoCoverActivity.find(
                (coach) => coach.uid === leave.coachUid
              )!
            );
          }
        }
        if (
          session.startTime <= leave.endDate &&
          session.endTime >= leave.endDate
        ) {
          if (
            !onLeaveCoaches.map((coach) => coach.uid).includes(leave.coachUid)
          ) {
            onLeaveCoaches.push(
              notWorkingCoachesWhoCoverActivity.find(
                (coach) => coach.uid === leave.coachUid
              )!
            );
          }
        }
      }
    }
    const availableCoachesWhoCoverActivity: Coach[] =
      notWorkingCoachesWhoCoverActivity.filter(
        (coach) => !onLeaveCoaches.includes(coach)
      );

    let coachRecommendations: CoachRecomendation[] = [];

    const baseDistanceMatrixUrl =
      "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric";
    const origins: string[] = availableCoachesWhoCoverActivity.map(
      (coach) => coach.baseEircode
    );
    const destinations: string = booking.client.eircode;
    const apiKey = mapsApiKey.value();
    const distanceMatrixUrl = `${baseDistanceMatrixUrl}&origins=${origins.join(
      "|"
    )}&destinations=${destinations}&key=${apiKey}`;

    const response = await fetch(distanceMatrixUrl);
    const data = await response.json();

    const rows = data.rows;

    for (const row of rows) {
      const elements = row.elements;
      for (const element of elements) {
        const travelEstimate = new TravelEstimate({
          distance: element.distance.value,
          duration: element.duration.value * 1000,
        });
        const coach = availableCoachesWhoCoverActivity[rows.indexOf(row)];
        const coachTravelEstimate = new CoachTravelEstimate({
          travelEstimate,
          coach,
        });
        const qoutaInfo = await QoutaInfo.buildProjectedQoutaInfo(
          booking.sessions,
          coachTravelEstimate
        );
        const coachRecommendation = new CoachRecomendation({
          coach,
          travelEstimate,
          qoutaInfo,
        });
        coachRecommendations.push(coachRecommendation);
      }
    }
    return coachRecommendations;
  }
);
