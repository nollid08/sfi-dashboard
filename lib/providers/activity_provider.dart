import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_provider.g.dart';

@riverpod
class Activities extends _$Activities {
  @override
  Stream<List<Activity>> build() async* {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    yield* db.collection('activities').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Activity.fromQueryDocSnapshot(doc);
      }).toList();
    });
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
    //Optimistic UI update
    final previousState = await future;
    state = AsyncData([...previousState, newActivity]);
    //Update Firestore
    await newActivityRef.set(newActivity.toDocument());
  }
}
