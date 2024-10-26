import {
  DocumentData,
  FirestoreDataConverter,
  QueryDocumentSnapshot,
} from "firebase-admin/firestore";

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

export const coachConverter: FirestoreDataConverter<Coach> = {
  toFirestore(coach: Coach) {
    return {
      uid: coach.uid,
      name: coach.name,
      baseEircode: coach.baseEircode,
      activitiesCovered: coach.activitiesCovered,
      timeToCover: coach.timeToCover,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot<DocumentData>): Coach {
    const data = snapshot.data();
    return new Coach({
      uid: snapshot.id,
      name: data.name,
      baseEircode: data.baseEircode,
      activitiesCovered: data.activitiesCovered,
      timeToCover: data.timeToCover,
    });
  },
};
