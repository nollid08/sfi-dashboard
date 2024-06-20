import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/session.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sessions_provider.g.dart';

@riverpod
Stream<List<Session>> sessions(SessionsRef ref,
    {IList<String>? bookingIds, IList<String>? coachIds}) async* {
  if (bookingIds != null && coachIds != null) {
    throw Exception('bookingIds OR coachIds must be provided, not both');
  }
  final db = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> sessionSnapshots;
  if (bookingIds != null ? bookingIds.isNotEmpty : false) {
    sessionSnapshots = db
        .collection('sessions')
        .where('bookingId', whereIn: bookingIds)
        .snapshots();
  } else {
    sessionSnapshots = db
        .collection('sessions')
        .where('coachIds', arrayContainsAny: coachIds)
        .snapshots();
  }
  yield* sessionSnapshots.map((snapshot) {
    return snapshot.docs.map((doc) {
      return Session.fromQueryDocSnapshot(doc);
    }).toList();
  });
}
