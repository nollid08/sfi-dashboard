export class ClientType {
    id: String;
    name: String;

    constructor(id: String, name: String) {
        this.id = id;
        this.name = name;
    }

    toString() {
        return `ClientType: ${this.id}, ${this.name}`;
    }
}