import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_provider.g.dart';

@riverpod
class Activities extends _$Activities {
  @override
  Future<List<Activity>> build() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> result =
        await _db.collection('activities').get();
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> activityDocs =
        result.docs;
    final List<Activity> activities = activityDocs
        .map((activity) => Activity.fromQueryDocSnapshot(activity))
        .toList();
    return activities;
  }

  Future<void> addActivity(
      {required String name,
      required IconData icon,
      required Color color}) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference<Map<String, dynamic>> newActivityRef =
        db.collection('activities').doc();
    final Activity newActivity = Activity(
      id: newActivityRef.id,
      name: name,
      icon: icon,
      color: color,
    );

    final previousState = await future;
    state = AsyncData([...previousState, newActivity]);
    await newActivityRef.set(newActivity.toDocument());

    // Trigger a rebuild of the UI
    ref.invalidateSelf();
    await future;
  }
}
