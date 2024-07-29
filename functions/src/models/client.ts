import { ClientType } from './client_type';

export class Client {
    id: String;
    name: String;
    addressLineOne: String;
    addressLineTwo: String;
    eircode: String;
    rollNumber: String;
    type: ClientType;


    constructor({ id, name, addressLineOne, addressLineTwo, eircode, rollNumber, clientType }: { id: String, name: String, addressLineOne: String, addressLineTwo: String, eircode: String, rollNumber: String, clientType: ClientType }) {
        this.id = id;
        this.name = name;
        this.addressLineOne = addressLineOne;
        this.addressLineTwo = addressLineTwo;
        this.eircode = eircode;
        this.rollNumber = rollNumber;
        this.type = clientType;
    }

    toString() {
        return `Client: ${this.id}, ${this.name}, ${this.addressLineOne}, ${this.addressLineTwo}, ${this.eircode}, ${this.rollNumber}, ${this.type}`;
    }
}

export interface ClientData {
    id: String;
    name: String;
    addressLineOne: String;
    addressLineTwo: String;
    eircode: String;
    rollNumber: String;
    type: ClientType;
}