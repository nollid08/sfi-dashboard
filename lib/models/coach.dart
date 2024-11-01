import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';

class Coach {
  final String uid;
  final String name;
  final String? baseEircode;
  final List<String> manuallyBookableActivites;
  final bool isAdmin;
  final Map<String, int> autoActivityRatings;

  Coach({
    required this.name,
    required this.uid,
    required this.baseEircode,
    required this.manuallyBookableActivites,
    required this.isAdmin,
    required this.autoActivityRatings,
  });

  factory Coach.fromQueryDocSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return Coach(
      uid: doc.id,
      name: data['name'],
      baseEircode: data['baseEircode'],
      manuallyBookableActivites:
          List<String>.from(data['activitiesCovered'] ?? []),
      isAdmin: data['isAdmin'] ?? false,
      autoActivityRatings: {
        for (String key in data.keys)
          if (key.startsWith('auto_score-'))
            key.substring('auto_score-'.length): data[key] as int? ?? 0
      },
    );
  }

  factory Coach.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Coach(
      uid: doc.id,
      name: data['name'],
      baseEircode: data['baseEircode'],
      manuallyBookableActivites:
          List<String>.from(data['activitiesCovered'] ?? []),
      isAdmin: data['isAdmin'] ?? false,
      autoActivityRatings: {
        for (String key in data.keys)
          if (key.startsWith('auto_score-'))
            key.substring('auto_score-'.length): data[key] as int? ?? 0
      },
    );
  }

  factory Coach.fromJson(Map<String, dynamic> json) {
    final Map<String, int> autoActivityRatings = {
      for (String key in json.keys)
        if (key.startsWith('auto_score-'))
          key.substring('auto_score-'.length): json[key] as int? ?? 0
    };
    return Coach(
      uid: json['uid'],
      name: json['name'],
      baseEircode: json['baseEircode'],
      manuallyBookableActivites: List<String>.from(json['activitiesCovered']),
      isAdmin: json['isAdmin'] ?? false,
      autoActivityRatings: autoActivityRatings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'baseEircode': baseEircode,
      'activitiesCovered': manuallyBookableActivites,
      'isAdmin': isAdmin,
      ...autoActivityRatings
          .map((key, value) => MapEntry('auto_score-$key', value)),
    };
  }

  Coach copyWith({
    String? name,
    String? baseEircode,
    List<String>? manuallyBookableActivites,
    bool? isAdmin,
    Map<String, int>? autoActivityRatings,
  }) {
    return Coach(
      uid: uid,
      name: name ?? this.name,
      baseEircode: baseEircode ?? this.baseEircode,
      manuallyBookableActivites:
          manuallyBookableActivites ?? this.manuallyBookableActivites,
      isAdmin: isAdmin ?? this.isAdmin,
      autoActivityRatings: autoActivityRatings ?? this.autoActivityRatings,
    );
  }
}
