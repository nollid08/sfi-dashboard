import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/leave.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leaves_provider.g.dart';

@riverpod
class Leaves extends _$Leaves {
  @override
  Stream<List<Leave>> build(IList<String> uids) async* {
    final db = FirebaseFirestore.instance;
    final leaves = uids.isEmpty
        ? db.collection('leaves').snapshots()
        : db
            .collection('leaves')
            .where('coachUid', whereIn: uids)
            .orderBy('startDate', descending: true)
            .snapshots();
    await for (final QuerySnapshot<Map<String, dynamic>> snapshot in leaves) {
      yield snapshot.docs.map((doc) {
        return Leave.fromQueryDocumentSnapshot(doc);
      }).toList();
    }
  }

  Future<void> addLeave(Leave leave) async {
    final db = FirebaseFirestore.instance;
    await db.collection('leaves').doc(leave.id).set(leave.toFBJson());
  }
}
