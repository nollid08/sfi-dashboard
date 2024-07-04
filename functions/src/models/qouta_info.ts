import { getFirestore } from "firebase-admin/firestore";
import { FortnightlyQoutaPercentage } from "./fortnightly_qouta_info";
import { Fortnight } from "./fortnight";
import { BookingSession, BookingSessionData } from "./session";
import { CoachTravelEstimate } from "./coach_travel_estimate";

export class QoutaInfo {
    currentAverageQoutaPercentage: number;
    projectedQoutaPercentage: number;
    currentFortnightlyQoutaPercentages: FortnightlyQoutaPercentage[];
    projectedFortnightlyQoutaPercentages: FortnightlyQoutaPercentage[];

    constructor({ currentQoutaPercentage, projectedQoutaPercentage, currentFortnightlyQoutaPercentages, projectedFortnightlyQoutaPercentages }: { currentQoutaPercentage: number, projectedQoutaPercentage: number, currentFortnightlyQoutaPercentages: FortnightlyQoutaPercentage[], projectedFortnightlyQoutaPercentages: FortnightlyQoutaPercentage[] }) {
        this.currentAverageQoutaPercentage = currentQoutaPercentage;
        this.projectedQoutaPercentage = projectedQoutaPercentage;
        this.currentFortnightlyQoutaPercentages = currentFortnightlyQoutaPercentages;
        this.projectedFortnightlyQoutaPercentages = projectedFortnightlyQoutaPercentages;
    }


    static async buildQoutaInfo(newSessions: BookingSession[], coachTravelEstimate: CoachTravelEstimate): Promise<QoutaInfo> {

        const db = getFirestore();
        const coach = coachTravelEstimate.coach;
        //Find earliest session start time
        const earliestSessionTime = newSessions.reduce((acc, session) => {
            if (session.arrivalTime < acc) {
                return session.arrivalTime;
            }
            return acc;
        }, newSessions[0].startTime);
        const latestSessionTime = newSessions.reduce((acc, session) => {
            if (session.leaveTime > acc) {
                return session.leaveTime;
            }
            return acc;
        }
            , newSessions[0].endTime);
        const fortnights: Fortnight[] = Fortnight.fromRange(earliestSessionTime, latestSessionTime);

        const currentFortnightlyQoutaPercentages: FortnightlyQoutaPercentage[] = [];
        const projectedFortnightlyQoutaPercentages: FortnightlyQoutaPercentage[] = [];
        let actualPercentageCovered: number = 0;
        let projectedPercentageCovered: number = 0;
        const sessionsRef = await db.collection('sessions').where('coaches', 'array-contains', coach.uid).where('arrivalTime', '>=', fortnights[0].startDate).where('leaveTime', '<=', fortnights[fortnights.length - 1].endDate).get();
        const sessionsDocs = sessionsRef.docs;
        const sessions: BookingSession[] = sessionsDocs.map((doc: any) => {
            const session: BookingSessionData = doc.data();
            return new BookingSession({
                id: doc.id,
                arrivalTime: session.arrivalTime.toDate(),
                leaveTime: session.leaveTime.toDate(),
                startTime: session.startTime.toDate(),
                endTime: session.endTime.toDate(),
                coaches: session.coaches,
                assignedCoaches: session.assignedCoaches,
            });
        });

        const currentCoachQouta = coach.timeToCover;

        for (const fortnight of fortnights) {
            const sessionsInFortnight = sessions.filter(session => session.arrivalTime >= fortnight.startDate && session.endTime <= fortnight.endDate);
            const newSessionsInFortnight = newSessions.filter(session => session.arrivalTime >= fortnight.startDate && session.endTime <= fortnight.endDate);
            const projectedSessionsInFortnight = sessionsInFortnight.concat(newSessionsInFortnight);
            let timeCoveredInFortnight = sessionsInFortnight.reduce((acc, session) => {
                if (session == undefined) {
                    return acc;
                }
                console.log("SessionTY", session.id);
                const totalsessionTime = session.endTime.getTime() - session.startTime.getTime();
                const overallTravelInfo = session.assignedCoaches.filter(assignedCoach => assignedCoach.coach.uid == coach.uid)[0].travelInfo;
                const OverallTravelTime = overallTravelInfo.duration * 2;
                let coveredTravelTime = OverallTravelTime >= 14400000 ? OverallTravelTime : OverallTravelTime - 3600000;
                if (coveredTravelTime < 0) {
                    coveredTravelTime = 0;
                }
                const timeCovered = totalsessionTime + coveredTravelTime;
                return acc + timeCovered;
            }, 0);

            actualPercentageCovered = timeCoveredInFortnight / currentCoachQouta;
            currentFortnightlyQoutaPercentages.push(new FortnightlyQoutaPercentage({ fortnight, qoutaPercentage: actualPercentageCovered }));

            //Calculate projected fortnight coverage
            let projectedTimeCoveredInFortnight = projectedSessionsInFortnight.reduce((acc, session) => {
                const totalsessionTime = session.endTime.getTime() - session.startTime.getTime();
                const overallTravelInfo = coachTravelEstimate.travelEstimate;
                const OverallTravelTime = overallTravelInfo.duration * 2;
                let coveredTravelTime = OverallTravelTime >= 14400000 ? OverallTravelTime : OverallTravelTime - 3600000;
                if (coveredTravelTime < 0) {
                    coveredTravelTime = 0;
                }
                const timeCovered = totalsessionTime + coveredTravelTime;
                return acc + timeCovered;
            }, 0);
            projectedPercentageCovered = projectedTimeCoveredInFortnight / currentCoachQouta;
            projectedFortnightlyQoutaPercentages.push(new FortnightlyQoutaPercentage({ fortnight, qoutaPercentage: projectedPercentageCovered }));
        }

        return new QoutaInfo({
            currentQoutaPercentage: actualPercentageCovered,
            projectedQoutaPercentage: projectedPercentageCovered,
            currentFortnightlyQoutaPercentages,
            projectedFortnightlyQoutaPercentages
        });
    }
}