import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'future_sessions_provider.g.dart';

@riverpod
Stream<List<Session>> futureSessions(FutureSessionsRef ref,
    {required String? coachUid}) async* {
  final db = FirebaseFirestore.instance;
  final Stream<QuerySnapshot<Map<String, dynamic>>> sessions = db
      .collection('sessions')
      .where('arrivalTime', isGreaterThan: DateTime.now())
      .snapshots();

  await for (final QuerySnapshot<Map<String, dynamic>> snapshot in sessions) {
    final List<Session> futureSessions =
        snapshot.docs.map((doc) => Session.fromQueryDocSnapshot(doc)).toList();
    if (coachUid != null) {
      yield futureSessions
          .where((session) =>
              session.assignedCoaches.any((ac) => ac.coach.uid == coachUid))
          .toList();
    } else {
      yield futureSessions;
    }
  }
}
