import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Activity({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'color': color.value,
    };
  }

  factory Activity.fromQueryDocSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    return Activity(
      id: document['id'] as String,
      name: document['name'] as String,
      icon: IconData(
        document['icon'] as int,
        fontFamily: 'MaterialIcons',
      ),
      color: Color(document['color'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'color': color.value,
    };
  }
}
