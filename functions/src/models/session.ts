export class BookingSession {
    id: String;
    arrivalTime: Date;
    leaveTime: Date;
    startTime: Date;
    activityEnd: Date;
    coaches: String[];

    constructor({ id, arrivalTime: arrivalTime, leaveTime: leaveTime, startTime: startTime, endTime: endTime, coaches }: { id: String, arrivalTime: Date, leaveTime: Date, startTime: Date, endTime: Date, coaches: String[] }) {
        this.id = id;
        this.arrivalTime = arrivalTime;
        this.leaveTime = leaveTime;
        this.startTime = startTime;
        this.activityEnd = endTime;
        this.coaches = coaches;
    }
}

export interface BookingSessionData {
    id: String;
    arrivalTime: Date;
    leaveTime: Date;
    startTime: Date;
    endTime: Date;
    coaches: String[];
}