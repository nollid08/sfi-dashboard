import {
  DocumentData,
  FirestoreDataConverter,
  QueryDocumentSnapshot,
} from "firebase-admin/firestore";
import { ClientType } from "./clientType";

export class Client {
  id: string;
  name: string;
  eircode: string;
  rollNumber: string;
  type: ClientType;
  town: string;
  county: string;
  isDeis: boolean;
  classrooms?: number;
  students: number;
  joinDate?: Date;
  previousBookingIds: string[];
  hasHall?: boolean;
  hasParking?: boolean;
  largestClassSize?: number;
  hasMats?: boolean;
  contactName?: string;
  contactEmail?: string;
  contactPhone?: string;
  principalName?: string;
  principalEmail?: string;
  notes?: string;
  startTime: Date;
  endTime: Date;

  constructor(
    id: string,
    name: string,
    eircode: string,
    rollNumber: string,
    typeId: string,
    town: string,
    county: string,
    isDeis: boolean,
    students: number,
    previousBookingIds: string[],
    classrooms?: number,
    joinDate?: Date,
    hasHall?: boolean,
    hasParking?: boolean,
    largestClassSize?: number,
    hasMats?: boolean,
    contactName?: string,
    contactEmail?: string,
    contactPhone?: string,
    principalName?: string,
    principalEmail?: string,
    notes?: string,
    startTime?: Date
  ) {
    this.id = id;
    this.name = name;
    this.eircode = eircode;
    this.rollNumber = rollNumber;
    this.type = new ClientType(typeId);
    this.town = town;
    this.county = county;
    this.isDeis = isDeis;
    this.students = students;
    this.previousBookingIds = previousBookingIds;
    this.classrooms = classrooms;
    this.joinDate = joinDate;
    this.hasHall = hasHall;
    this.hasParking = hasParking;
    this.largestClassSize = largestClassSize;
    this.hasMats = hasMats;
    this.contactName = contactName;
    this.contactEmail = contactEmail;
    this.contactPhone = contactPhone;
    this.principalName = principalName;
    this.principalEmail = principalEmail;
    this.notes = notes;
    this.startTime = startTime ?? new Date(0, 0, 0, 9, 10);

    this.endTime = new Date(
      this.startTime.getTime() + 5 * 60 * 60 * 1000 + 40 * 60 * 1000
    );
  }
}

export const clientConverter: FirestoreDataConverter<Client> = {
  toFirestore(client: Client) {
    return {
      id: client.id,
      name: client.name,
      eircode: client.eircode,
      rollNumber: client.rollNumber,
      type: client.type.id,
      town: client.town,
      county: client.county,
      isDeis: client.isDeis,
      classrooms: client.classrooms,
      students: client.students,
      joinDate: client.joinDate,
      previousBookingIds: client.previousBookingIds,
      hasHall: client.hasHall,
      hasParking: client.hasParking,
      largestClassSize: client.largestClassSize,
      hasMats: client.hasMats,
      contactName: client.contactName,
      contactEmail: client.contactEmail,
      contactPhone: client.contactPhone,
      principalName: client.principalName,
      principalEmail: client.principalEmail,
      notes: client.notes,
      startTime: client.startTime,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot<DocumentData>): Client {
    const data = snapshot.data();
    return new Client(
      snapshot.id,
      data.name,
      data.eircode,
      data.rollNumber,
      data.type,
      data.town ?? "N/P",
      data.county ?? "N/P",
      data.isDeis,
      data.students,
      data.previousBookingIds,
      data.classrooms,
      data.joinDate,
      data.hasHall,
      data.hasParking,
      data.largestClassSize,
      data.hasMats,
      data.contactName,
      data.contactEmail,
      data.contactPhone,
      data.principalName,
      data.principalEmail,
      data.notes,
      data.startTime
    );
  },
};
