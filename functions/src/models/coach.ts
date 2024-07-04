export class Coach {
    uid: String;
    name: String;
    baseEircode: String;
    activitiesCovered: Array<String>;
    timeToCover: number;


    constructor({ uid, name, baseEircode, activitiesCovered, timeToCover }: { uid: String, name: String, baseEircode: String, activitiesCovered: Array<String>, timeToCover: number }) {
        this.uid = uid;
        this.name = name;
        this.baseEircode = baseEircode;
        this.activitiesCovered = activitiesCovered;
        this.timeToCover = timeToCover;
    }
}