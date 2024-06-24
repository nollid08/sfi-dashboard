export class Activity {
    id: String;
    name: String;
    icon: String;
    color: String;

    constructor(id: String, name: String, icon: String, color: String) {
        this.id = id;
        this.name = name;
        this.icon = icon;
        this.color = color;
    }

    toString() {
        return `Activity: ${this.id}, ${this.name}, ${this.icon}, ${this.color}`;
    }
}