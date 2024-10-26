export class ProvisionalSession {
  arrivalTime: Date;
  startTime: Date;
  endTime: Date;
  leaveTime: Date;

  constructor({
    arrivalTime,
    startTime,
    endTime,
    leaveTime,
  }: {
    arrivalTime: Date;
    startTime: Date;
    endTime: Date;
    leaveTime: Date;
  }) {
    this.arrivalTime = arrivalTime;
    this.startTime = startTime;
    this.endTime = endTime;
    this.leaveTime = leaveTime;
  }

  static fromDate(
    date: Date,
    schoolOpeningTime: Date,
    schoolClosingTime: Date
  ): ProvisionalSession {
    const start = new Date(
      date.setHours(
        schoolOpeningTime.getHours(),
        schoolOpeningTime.getMinutes()
      )
    );
    const arrival = new Date(start.setMinutes(start.getMinutes() - 30));
    const end = new Date(
      date.setHours(
        schoolClosingTime.getHours(),
        schoolClosingTime.getMinutes()
      )
    );
    const leave = new Date(end.setMinutes(end.getMinutes() + 30));

    return new ProvisionalSession({
      arrivalTime: arrival,
      startTime: start,
      endTime: end,
      leaveTime: leave,
    });
  }
}
