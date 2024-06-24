export class Coach {
    uid: String;
    name: String;
    eircode: String;
    activitiesCovered: Array<String>;

    constructor(uid: String, name: String, eircode: String, activitiesCovered: Array<String>) {
        this.uid = uid;
        this.name = name;
        this.activitiesCovered = activitiesCovered;
        this.eircode = eircode;
    }
}