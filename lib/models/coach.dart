import 'package:cloud_firestore/cloud_firestore.dart';

class Coach {
  final String uid;
  final String name;
  final String baseEircode;
  final List<String> activitiesCovered;

  Coach({
    required this.name,
    required this.uid,
    required this.baseEircode,
    required this.activitiesCovered,
  });

  factory Coach.fromQueryDocSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final String baseEircode = data['baseEircode'] ?? 'p67RC92';
    final List<String> activitiesCovered = data['activitiesCovered'] != null
        ? List<String>.from(data['activitiesCovered'])
        : [];
    return Coach(
      uid: doc.id,
      name: doc['name'],
      baseEircode: baseEircode,
      activitiesCovered: activitiesCovered,
    );
  }

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      uid: json['uid'],
      name: json['name'],
      baseEircode: json['eircode'],
      activitiesCovered: List<String>.from(json['activitiesCovered']),
    );
  }
}
