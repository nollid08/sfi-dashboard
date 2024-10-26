import {
  DocumentData,
  FirestoreDataConverter,
  QueryDocumentSnapshot,
} from "firebase-admin/firestore";

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
}

export const activityConverter: FirestoreDataConverter<Activity> = {
  toFirestore(activity: Activity) {
    return {
      id: activity.id,
      name: activity.name,
      icon: activity.icon,
      color: activity.color,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot<DocumentData>): Activity {
    const data = snapshot.data();
    return new Activity(snapshot.id, data.name, data.icon, data.color);
  },
};
