import { onCall, CallableRequest } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { getFirestore } from "firebase-admin/firestore";
import { coachConverter } from "../nModels/coach";
import { CandidateCoach } from "../nModels/candidate_coach";
import { Client } from "../nModels/client";
import { sessionConverter } from "../nModels/session";
import { ProvisionalBooking } from "../nModels/provisional_booking";
import { RecommendedBooking } from "../nModels/booking";
import { Activity } from "../nModels/activity";

const mapsApiKey = defineSecret("MAPS_API_KEY");
export const find_available_booking_options_function = onCall(
  { secrets: [mapsApiKey] },
  async (request: CallableRequest) => {
    console.log("Finding available booking options Running");
    const db = getFirestore();

    const requestData: {
      requestedActivities: Activity[];
      selectedHalfTerms: HalfTerm[];
      client: Client;
    } = request.data;

    const requestedActivities: Activity[] = requestData.requestedActivities;
    const selectedHalfTerms: HalfTerm[] = requestData.selectedHalfTerms;
    const client: Client = requestData.client;

    console.log(`Finding available booking options for client ${client.name}`);
    console.log(
      `Selected half terms: ${selectedHalfTerms.map((halfTerm) => halfTerm.id)}`
    );
    console.log(
      `Requested activities: ${requestedActivities.map(
        (activity) => activity.id
      )}`
    );

    const coaches = (
      await db
        .collection("users")
        .where(
          "activitiesCovered",
          "array-contains-any",
          requestedActivities.map((activity) => activity.id)
        )
        .withConverter(coachConverter)
        .get()
    ).docs.map((doc) => doc.data());

    console.log(`Found ${coaches.length} coaches`);

    const earliestDate = selectedHalfTerms.reduce(
      (earliest, halfTerm) =>
        halfTerm.startDate < earliest ? halfTerm.startDate : earliest,
      selectedHalfTerms[0].startDate
    );
    console.log(`Earliest date: ${new Date(earliestDate).toString()}`);

    const latestDate = new Date(
      selectedHalfTerms.reduce(
        (latest, halfTerm) =>
          halfTerm.endDate > latest ? halfTerm.endDate : latest,
        selectedHalfTerms[0].endDate
      )
    );
    console.log(`Latest date: ${new Date(latestDate).toString()}`);

    const sessions = (
      await db
        .collection("sessions")
        .where("startTime", ">", new Date(earliestDate))
        .where("endTime", "<", new Date(latestDate))
        .withConverter(sessionConverter)
        .get()
    ).docs.map((doc) => doc.data());

    console.log(`Found ${sessions.length} sessions`);

    const candidateCoaches = await CandidateCoach.buildCandidateCoaches(
      coaches,
      client,
      sessions,
      mapsApiKey.value()
    );

    console.log(`Found ${candidateCoaches.length} candidate coaches`);

    if (candidateCoaches.length === 0) {
      console.error("No candidate coaches found");
      return [];
    }

    const allPossibleStartingSessionDates = selectedHalfTerms.flatMap(
      (halfTerm) => {
        const startingSessionDates: Date[] = [];
        let currentDate = new Date(halfTerm.startDate);

        const minimumDate = addWorkDays(new Date(), 3);
        if (currentDate < minimumDate) {
          currentDate = minimumDate;
        }

        while (currentDate <= latestDate) {
          //Check if the current date is not an excluded day
          const isExcludedDay = halfTerm.excludedDates.some((excludedDate) => {
            if (
              new Date(excludedDate).getMonth() === currentDate.getMonth() &&
              new Date(excludedDate).getDate() === currentDate.getDate()
            ) {
              return true;
            } else {
              return false;
            }
          });

          const isWeekday =
            currentDate.getDay() !== 0 && currentDate.getDay() !== 6;
          if (!isExcludedDay && isWeekday) {
            console.log(`Adding ${currentDate} to possible starting dates`);
            startingSessionDates.push(new Date(currentDate));
          }
          currentDate = new Date(
            currentDate.setDate(currentDate.getDate() + 1)
          );
        }
        return startingSessionDates;
      }
    );

    console.log(
      `Found ${allPossibleStartingSessionDates.length} possible starting session dates`
    );

    const allProvisionalBookings: ProvisionalBooking[] =
      allPossibleStartingSessionDates
        .flatMap((startingSessionDate) => {
          return selectedHalfTerms.map((halfTerm) => {
            return ProvisionalBooking.fromStartDate({
              startDate: startingSessionDate,
              client,
              halfTerm,
            });
          });
        })
        .filter((booking) => booking !== null) as ProvisionalBooking[];

    console.log(
      `Generated ${allProvisionalBookings.length} provisional bookings`
    );

    const recommendedBookings: RecommendedBooking[] =
      requestedActivities.flatMap((activity) => {
        const suitableCoaches = candidateCoaches.filter((candidateCoach) =>
          candidateCoach.isSuitable(activity)
        );
        const suitableBookings: RecommendedBooking[] = allProvisionalBookings
          .flatMap((provisionalBooking) => {
            // Coaches who do not already have sessions on the day (any time) of the provisional booking
            const availableCoaches: CandidateCoach[] = suitableCoaches.filter(
              (candidateCoach) => {
                const coachSessions = sessions.filter((session) =>
                  session.coaches.includes(candidateCoach.coach.uid)
                );
                const coachSessionDates: Date[] = coachSessions.map(
                  (session) => new Date(session.startTime.setHours(0, 0, 0, 0))
                );
                const coachSessionTimes: number[] = coachSessions.map(
                  (session) => session.startTime.getTime()
                );

                if (coachSessionDates.length === 0) {
                  return true;
                }

                const clash = provisionalBooking.sessions.some((session) => {
                  const sessionTime = new Date(
                    session.startTime.setHours(0, 0, 0, 0)
                  ).getTime();

                  return coachSessionTimes.includes(sessionTime);
                });
                return !clash;
              }
            );
            if (availableCoaches.length === 0) {
              return null;
            }
            //Select the best coaches from the available coaches
            const bestCoach = availableCoaches.reduce((best, current) =>
              best.calculateCoachScore() > current.calculateCoachScore()
                ? best
                : current
            );

            const booking = RecommendedBooking.fromProvisionalBooking(
              provisionalBooking,
              activity,
              bestCoach,
              undefined
            );

            return booking;
          })
          .filter((booking) => booking !== null) as RecommendedBooking[];

        console.log(
          `Found ${suitableBookings.length} suitable bookings for activity ${activity.id}`
        );
        return suitableBookings;
      });

    console.log(`Found ${recommendedBookings.length} recommended bookings`);

    // const stringifiedBookings = JSON.stringify(

    // );

    recommendedBookings.sort((a, b) => {
      // Sort primarily by score in ascending order
      const scoreComparison = a.score - b.score;
      if (scoreComparison !== 0) {
        return scoreComparison;
      }

      // If scores are equal, sort by date in ascending order (closest first)
      return (
        a.sessions[0].startTime.getTime() - b.sessions[0].startTime.getTime()
      ); // Reverse the comparison for closest first
    });

    return {
      reccomendedBookings: recommendedBookings.map((booking) =>
        booking.serialise()
      ),
    };
  }
);

function addWorkDays(startDate: Date, days: number) {
  // Get the day of the week as a number (0 = Sunday, 1 = Monday, .... 6 = Saturday)
  var dow = startDate.getDay();
  var daysToAdd = days;
  // If the current day is Sunday add one day
  if (dow == 0) daysToAdd++;
  // If the start date plus the additional days falls on or after the closest Saturday calculate weekends
  if (dow + daysToAdd >= 6) {
    //Subtract days in current working week from work days
    var remainingWorkDays = daysToAdd - (5 - dow);
    //Add current working week's weekend
    daysToAdd += 2;
    if (remainingWorkDays > 5) {
      //Add two days for each working week by calculating how many weeks are included
      daysToAdd += 2 * Math.floor(remainingWorkDays / 5);
      //Exclude final weekend if remainingWorkDays resolves to an exact number of weeks
      if (remainingWorkDays % 5 == 0) daysToAdd -= 2;
    }
  }
  startDate.setDate(startDate.getDate() + daysToAdd);
  return startDate;
}
