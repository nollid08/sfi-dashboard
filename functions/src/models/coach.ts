export class Coach {
  uid: string;
  name: string;
  baseEircode: string;
  activitiesCovered: Array<string>;
  timeToCover: number;
  autoActivityRatings: { [activityId: string]: number } = {};

  constructor({
    uid,
    name,
    baseEircode,
    activitiesCovered,
    timeToCover,
    autoActivityRatings,
  }: {
    uid: string;
    name: string;
    baseEircode: string;
    activitiesCovered: Array<string>;
    timeToCover: number;
    autoActivityRatings: { [activityId: string]: number };
  }) {
    this.uid = uid;
    this.name = name;
    this.baseEircode = baseEircode;
    this.activitiesCovered = activitiesCovered;
    this.timeToCover = timeToCover;
    this.autoActivityRatings = autoActivityRatings;
  }
}
