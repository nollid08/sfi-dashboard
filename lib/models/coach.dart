import 'package:cloud_firestore/cloud_firestore.dart';

class Coach {
  final String uid;
  final String name;
  final String? baseEircode;
  final List<String> activitiesCovered;
  final bool isAdmin;

  Coach({
    required this.name,
    required this.uid,
    required this.baseEircode,
    required this.activitiesCovered,
    required this.isAdmin,
  });

  factory Coach.fromQueryDocSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final String? baseEircode = data['baseEircode'];
    final List<String> activitiesCovered = data['activitiesCovered'] != null
        ? List<String>.from(data['activitiesCovered'])
        : [];
    final bool isAdmin = data['isAdmin'] ?? false;
    return Coach(
      uid: doc.id,
      name: doc['name'],
      baseEircode: baseEircode,
      activitiesCovered: activitiesCovered,
      isAdmin: isAdmin,
    );
  }

  factory Coach.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Coach not found');
    }
    final String baseEircode = data['baseEircode'] ?? 'p67RC92';
    final List<String> activitiesCovered = data['activitiesCovered'] != null
        ? List<String>.from(data['activitiesCovered'])
        : [];
    final bool isAdmin = data['isAdmin'] ?? false;
    return Coach(
      uid: doc.id,
      name: doc['name'],
      baseEircode: baseEircode,
      activitiesCovered: activitiesCovered,
      isAdmin: isAdmin,
    );
  }

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      uid: json['uid'],
      name: json['name'],
      baseEircode: json['baseEircode'],
      activitiesCovered: List<String>.from(json['activitiesCovered']),
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'eircode': baseEircode,
      'activitiesCovered': activitiesCovered,
      'isAdmin': isAdmin,
    };
  }
}
