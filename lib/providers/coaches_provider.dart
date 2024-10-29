import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/activity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coaches_provider.g.dart';

@riverpod
class Coaches extends _$Coaches {
  @override
  Stream<List<Coach>> build() async* {
    final activities = await ref.watch(activitiesProvider.future);
    final db = FirebaseFirestore.instance;
    final coachesCollection = db.collection('users');
    yield* coachesCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        return Coach.fromQueryDocSnapshot(doc);
      }).toList();
    });
  }

  Future<bool> toggleActivity(String coachId, String activityId) async {
    final db = FirebaseFirestore.instance;

    final coachDoc = await db.collection('users').doc(coachId).get();
    final data = coachDoc.data();
    if (data == null) {
      throw Exception('Coach not found');
    }
    final List<String> activitiesCovered = data['activitiesCovered'] != null
        ? List<String>.from(data['activitiesCovered'])
        : [];
    bool isCoveredAfterToggle;
    if (activitiesCovered.contains(activityId)) {
      activitiesCovered.remove(activityId);
      isCoveredAfterToggle = false;
    } else {
      activitiesCovered.add(activityId);
      isCoveredAfterToggle = true;
    }
    await db.collection('users').doc(coachId).update({
      'activitiesCovered': activitiesCovered,
    });
    state = state;
    return isCoveredAfterToggle;
  }

  Future<int> updateAutoActivityRating(
      {required String coachId,
      required String activityId,
      required int newRating}) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('users')
        .doc(coachId)
        .update({'auto_score-$activityId': newRating});
    return newRating;
  }

  Future<Coach> updateCoach(Coach updatedCoach) async {
    final db = FirebaseFirestore.instance;
    await db.collection('users').doc(updatedCoach.uid).update(
          updatedCoach.toJson(),
        );
    return updatedCoach;
  }
}

@riverpod
Future<Coach> coach(CoachRef ref, String coachId) async {
  final activities = await ref.watch(activitiesProvider.future);
  final db = FirebaseFirestore.instance;
  final coachDoc = db.collection('users').doc(coachId);
  final DocumentSnapshot<Map<String, dynamic>> coachData = await coachDoc.get();
  return Coach.fromDocSnapshot(coachData);
}
