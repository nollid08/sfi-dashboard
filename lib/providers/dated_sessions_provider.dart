import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dated_sessions_provider.g.dart';

@riverpod
class DatedSessions extends _$DatedSessions {
  @override
  Stream<List<Session>> build(
      {required DateTime startDate, required DateTime endDate}) async* {
    final db = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> sessionSnapshots = db
        .collection('sessions')
        .where('arrivalTime', isGreaterThanOrEqualTo: startDate)
        .where('arrivalTime', isLessThanOrEqualTo: endDate)
        .orderBy('arrivalTime', descending: false)
        .snapshots();
    yield* sessionSnapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return Session.fromQueryDocSnapshot(doc);
      }).toList();
    });
  }
}
