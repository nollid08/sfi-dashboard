import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/assigned_coach.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_recommendation.dart';
import 'package:dashboard/models/session.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_sessions_provider.g.dart';

@riverpod
class AllSessions extends _$AllSessions {
  @override
  Stream<List<Session>> build() async* {
    final db = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> sessionSnapshots;
    sessionSnapshots = db
        .collection('sessions')
        .orderBy('arrivalTime', descending: false)
        .snapshots();
    yield* sessionSnapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return Session.fromQueryDocSnapshot(doc);
      }).toList();
    });
  }

  Future<void> updateSessionDateTimes({
    required String sessionId,
    DateTime? newArrivalTime,
    DateTime? newStartTime,
    DateTime? newEndTime,
    DateTime? newLeaveTime,
  }) async {
    final db = FirebaseFirestore.instance;
    // Onlu update if Dattime is not null
    await db.collection('sessions').doc(sessionId).update({
      if (newArrivalTime != null) 'arrivalTime': newArrivalTime,
      if (newStartTime != null) 'startTime': newStartTime,
      if (newEndTime != null) 'endTime': newEndTime,
      if (newLeaveTime != null) 'leaveTime': newLeaveTime,
    });
  }

  Future<void> updateAllSessionTimes({
    required String bookingId,
    required String sessionId,
    DateTime? newArrivalTime,
    DateTime? newStartTime,
    DateTime? newEndTime,
    DateTime? newLeaveTime,
  }) async {
    final db = FirebaseFirestore.instance;
    final QuerySnapshot sessionSnapshots = await db
        .collection('sessions')
        .where('bookingId', isEqualTo: bookingId)
        .get();
    final List<Session> sessions = sessionSnapshots.docs
        .map((doc) => Session.fromQueryDocSnapshot(doc))
        .toList();

    final batch = db.batch();
    for (final Session session in sessions) {
      final DateTime oldArrivalTime = session.arrivalTime;
      final DateTime oldStartTime = session.startTime;
      final DateTime oldEndTime = session.endTime;
      final DateTime oldLeaveTime = session.leaveTime;

      final DateTime adjustedArrivalTime = newArrivalTime != null
          ? oldArrivalTime.copyWith(
              hour: newArrivalTime.hour,
              minute: newArrivalTime.minute,
            )
          : oldArrivalTime;
      final DateTime adjustedStartTime = newStartTime != null
          ? oldStartTime.copyWith(
              hour: newStartTime.hour,
              minute: newStartTime.minute,
            )
          : oldStartTime;
      final DateTime adjustedEndTime = newEndTime != null
          ? oldEndTime.copyWith(
              hour: newEndTime.hour,
              minute: newEndTime.minute,
            )
          : oldEndTime;
      final DateTime adjustedLeaveTime = newLeaveTime != null
          ? oldLeaveTime.copyWith(
              hour: newLeaveTime.hour,
              minute: newLeaveTime.minute,
            )
          : oldLeaveTime;
      final DocumentReference<Map<String, dynamic>> sessionRef =
          db.collection('sessions').doc(session.id);
      batch.update(sessionRef, {
        'arrivalTime': adjustedArrivalTime,
        'startTime': adjustedStartTime,
        'endTime': adjustedEndTime,
        'leaveTime': adjustedLeaveTime,
      });
    }
    await batch.commit();
  }

  Future<void> removeCoachesFromSession({
    required Session session,
    required List<Coach> coaches,
  }) async {
    final db = FirebaseFirestore.instance;
    final DocumentReference<Map<String, dynamic>> sessionRef =
        db.collection('sessions').doc(session.id);
    final transaction = await db.runTransaction((transaction) async {
      final DocumentSnapshot<Map<String, dynamic>> sessionSnapshot =
          await transaction.get(sessionRef);
      final Map<String, dynamic>? sessionData = sessionSnapshot.data();
      if (sessionData == null) {
        throw Exception('Session not found');
      }

      final List assignedCoachesData = sessionData['assignedCoaches'];
      final List<AssignedCoach> assignedCoaches = assignedCoachesData
          .map((assignedCoachData) => AssignedCoach.fromJson(assignedCoachData))
          .toList();

      final List<AssignedCoach> updatedAssignedCoaches = assignedCoaches
          .where((assignedCoach) =>
              !coaches.any((coach) => coach.uid == assignedCoach.coach.uid))
          .toList();
      transaction.update(sessionRef, {
        'assignedCoaches': updatedAssignedCoaches
            .map((assignedCoach) => assignedCoach.toJson())
            .toList(),
      });
      transaction.update(sessionRef, {
        'coaches': FieldValue.arrayRemove(coaches.map((e) => e.uid).toList()),
      });
    });
  }

  Future<void> removeCoachesFromAllSessionsInBooking({
    required String bookingId,
    required List<Coach> coachesToRemove,
    required List<AssignedCoach> assignedCoaches,
  }) async {
    final db = FirebaseFirestore.instance;
    final QuerySnapshot sessionSnapshots = await db
        .collection('sessions')
        .where('bookingId', isEqualTo: bookingId)
        .get();
    final List<Session> sessions = sessionSnapshots.docs
        .map((doc) => Session.fromQueryDocSnapshot(doc))
        .toList();
    final List<DocumentReference<Map<String, dynamic>>> sessionRefs = sessions
        .map((session) => db.collection('sessions').doc(session.id))
        .toList();
    final transaction = await db.runTransaction((transaction) async {
      try {
        final List<List<AssignedCoach>> currentAssignedCoachesPerSession =
            await Future.wait(sessionRefs.map((sessionRef) async {
          final DocumentSnapshot<Map<String, dynamic>> sessionSnapshot =
              await transaction.get(sessionRef);
          final Map<String, dynamic>? sessionData = sessionSnapshot.data();
          if (sessionData == null) {
            throw Exception('Session not found');
          }
          final List assignedCoachesData = sessionData['assignedCoaches'];
          return assignedCoachesData
              .map((assignedCoachData) =>
                  AssignedCoach.fromJson(assignedCoachData))
              .toList();
        }).toList());

        final List<List<AssignedCoach>> updatedAssignedCoachesPerSession =
            currentAssignedCoachesPerSession
                .map((assignedCoaches) => assignedCoaches
                    .where((assignedCoach) => !coachesToRemove
                        .any((coach) => coach.uid == assignedCoach.coach.uid))
                    .toList())
                .toList();

        for (final sessionRef in sessionRefs) {
          final List<AssignedCoach> updatedAssignedCoaches =
              updatedAssignedCoachesPerSession.removeAt(0);
          transaction.update(sessionRef, {
            'assignedCoaches': updatedAssignedCoaches
                .map((assignedCoach) => assignedCoach.toJson())
                .toList(),
          });
          transaction.update(sessionRef, {
            'coaches': FieldValue.arrayRemove(
                coachesToRemove.map((e) => e.uid).toList()),
          });
        }
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> addCoachesToSession({
    required Session session,
    required List<CoachRecommendation> coachesRecommendationsToAdd,
  }) async {
    final db = FirebaseFirestore.instance;
    final DocumentReference<Map<String, dynamic>> sessionRef =
        db.collection('sessions').doc(session.id);
    final transaction = await db.runTransaction((transaction) async {
      final DocumentSnapshot<Map<String, dynamic>> sessionSnapshot =
          await transaction.get(sessionRef);
      final Map<String, dynamic>? sessionData = sessionSnapshot.data();
      if (sessionData == null) {
        throw Exception('Session not found');
      }

      final List assignedCoachesData = sessionData['assignedCoaches'];
      final List<AssignedCoach> assignedCoaches = assignedCoachesData
          .map((assignedCoachData) => AssignedCoach.fromJson(assignedCoachData))
          .toList();

      final List<AssignedCoach> assignedCoachesToAdd =
          coachesRecommendationsToAdd
              .map((coachRecommendation) =>
                  AssignedCoach.fromRecommendation(coachRecommendation))
              .toList();
      final List<AssignedCoach> updatedAssignedCoaches = [
        ...assignedCoaches,
        ...assignedCoachesToAdd
      ];
      transaction.update(sessionRef, {
        'assignedCoaches': updatedAssignedCoaches
            .map((assignedCoach) => assignedCoach.toJson())
            .toList(),
      });
      transaction.update(sessionRef, {
        'coaches': FieldValue.arrayUnion(
            updatedAssignedCoaches.map((e) => e.coach.uid).toList()),
      });
    });
  }

  Future<void> addCoachesToAllSessionsInBooking({
    required String bookingId,
    required List<CoachRecommendation> coachesRecommendationsToAdd,
  }) async {
    final db = FirebaseFirestore.instance;
    final QuerySnapshot sessionSnapshots = await db
        .collection('sessions')
        .where('bookingId', isEqualTo: bookingId)
        .get();
    final List<Session> sessions = sessionSnapshots.docs
        .map((doc) => Session.fromQueryDocSnapshot(doc))
        .toList();
    final List<DocumentReference<Map<String, dynamic>>> sessionRefs = sessions
        .map((session) => db.collection('sessions').doc(session.id))
        .toList();
    final List<Session> allSessionsinBooking = sessionSnapshots.docs
        .map((doc) => Session.fromQueryDocSnapshot(doc))
        .toList();
    final batch = db.batch();

    for (final session in allSessionsinBooking) {
      final List<AssignedCoach> currentlyAssignedCoaches =
          session.assignedCoaches;
      final List<AssignedCoach> coachesToAdd = coachesRecommendationsToAdd
          .map((coachRecommendation) =>
              AssignedCoach.fromRecommendation(coachRecommendation))
          .toList();

      final List<AssignedCoach> updatedAssignedCoaches = [
        ...currentlyAssignedCoaches,
        ...coachesToAdd
      ];
      final DocumentReference<Map<String, dynamic>> sessionRef =
          db.collection('sessions').doc(session.id);
      batch.update(sessionRef, {
        'assignedCoaches': updatedAssignedCoaches
            .map((assignedCoach) => assignedCoach.toJson())
            .toList(),
      });
      batch.update(sessionRef, {
        'coaches': FieldValue.arrayUnion(
            updatedAssignedCoaches.map((e) => e.coach.uid).toList()),
      });
    }
    await batch.commit();
  }

  Future<void> updateSessionNotes({
    required String sessionId,
    required String newNotes,
  }) async {
    final db = FirebaseFirestore.instance;
    await db.collection('sessions').doc(sessionId).update({
      'notes': newNotes,
    });
  }

  Future<void> deleteSession({required String sessionId}) async {
    final db = FirebaseFirestore.instance;
    await db.collection('sessions').doc(sessionId).delete();
  }

  Future<void> addSession(Session newSession) async {
    final db = FirebaseFirestore.instance;
    await db.collection('sessions').doc(newSession.id).set(newSession.toDoc());
  }
}
