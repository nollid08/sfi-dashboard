export class Activity {
  id: string;
  name: string;
  icon: string;
  color: string;

  constructor(id: string, name: string, icon: string, color: string) {
    this.id = id;
    this.name = name;
    this.icon = icon;
    this.color = color;
  }

  toString() {
    return `Activity: ${this.id}, ${this.name}, ${this.icon}, ${this.color}`;
  }
}

export interface ActivityData {
  id: string;
  name: string;
  icon: string;
  color: string;
}
