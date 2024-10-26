import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_linked_leave.dart';
import 'package:dashboard/models/leave.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coach_linked_leaves_provider.g.dart';

@riverpod
class CoachLinkedLeaves extends _$CoachLinkedLeaves {
  @override
  Stream<List<CoachLinkedLeave>> build() async* {
    final db = FirebaseFirestore.instance;
    final List<Coach> coaches = await db.collection('users').get().then(
          (value) =>
              value.docs.map((doc) => Coach.fromDocSnapshot(doc)).toList(),
        );

    final leaves = db.collection('leaves').snapshots();

    await for (final QuerySnapshot<Map<String, dynamic>> snapshot in leaves) {
      yield snapshot.docs.map((doc) {
        final data = doc.data();
        final Coach coach =
            coaches.firstWhere((coach) => coach.uid == data['coachUid']);
        return CoachLinkedLeave.fromQueryDocumentSnapshot(doc, coach);
      }).toList();
    }
  }

  Future<void> addLeave(Leave leave) async {
    final db = FirebaseFirestore.instance;
    await db.collection('leaves').doc(leave.id).set(leave.toFBJson());
  }

  Future<void> approveLeave(CoachLinkedLeave coachLinkedLeave) async {
    final db = FirebaseFirestore.instance;
    await db.collection('leaves').doc(coachLinkedLeave.id).update({
      'status': LeaveStatus.approved.index,
    });
  }

  Future<void> rejectLeave(CoachLinkedLeave coachLinkedLeave) async {
    final db = FirebaseFirestore.instance;
    await db.collection('leaves').doc(coachLinkedLeave.id).update({
      'status': LeaveStatus.rejected.index,
    });
  }
}
