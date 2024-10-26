export class Coach {
  uid: string;
  name: string;
  baseEircode: string;
  activitiesCovered: Array<string>;
  timeToCover: number;

  constructor({
    uid,
    name,
    baseEircode,
    activitiesCovered,
    timeToCover,
  }: {
    uid: string;
    name: string;
    baseEircode: string;
    activitiesCovered: Array<string>;
    timeToCover: number;
  }) {
    this.uid = uid;
    this.name = name;
    this.baseEircode = baseEircode;
    this.activitiesCovered = activitiesCovered;
    this.timeToCover = timeToCover;
  }
}
