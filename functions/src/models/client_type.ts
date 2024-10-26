export class ClientType {
  id: string;
  name: string;

  constructor(id: string, name: string) {
    this.id = id;
    this.name = name;
  }

  toString() {
    return `ClientType: ${this.id}, ${this.name}`;
  }
}
