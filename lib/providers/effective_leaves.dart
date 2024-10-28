import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/leave.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'effective_leaves.g.dart';

@riverpod
Stream<List<Leave>> effectiveLeaves(EffectiveLeavesRef ref, String uid) async* {
  final db = FirebaseFirestore.instance;
  final Stream<List<Leave>> upcomingLeavesStream = db
      .collection('leaves')
      .where(
        'coachUid',
        isEqualTo: uid,
      )
      .where(
        'status',
        isNotEqualTo: LeaveStatus.rejected.index,
      )
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map((doc) => Leave.fromQueryDocumentSnapshot(doc))
            .toList(),
      );

  yield* upcomingLeavesStream;
}
