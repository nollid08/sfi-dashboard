import { ClientType } from './client_type';

export class Client {
    id: String;
    name: String;
    addressLineOne: String;
    addressLineTwo: String;
    eircode: String;
    rollNumber: String;
    clientType: ClientType;


    constructor(id: String, name: String, addressLineOne: String, addressLineTwo: String, eircode: String, rollNumber: String, clientType: ClientType) {
        this.id = id;
        this.name = name;
        this.addressLineOne = addressLineOne;
        this.addressLineTwo = addressLineTwo;
        this.eircode = eircode;
        this.rollNumber = rollNumber;
        this.clientType = clientType;
    }

    toString() {
        return `Client: ${this.id}, ${this.name}, ${this.addressLineOne}, ${this.addressLineTwo}, ${this.eircode}, ${this.rollNumber}, ${this.clientType}`;
    }
}