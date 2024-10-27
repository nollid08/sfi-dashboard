import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/leave.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dated_leaves_provider.g.dart';

@riverpod
class DatedLeaves extends _$DatedLeaves {
  @override
  Stream<List<Leave>> build(
      {required DateTime startDate, required DateTime endDate}) async* {
    final db = FirebaseFirestore.instance;
    final leaves = db
        .collection('leaves')
        .where('startDate', isGreaterThanOrEqualTo: startDate)
        .where('endDate', isLessThanOrEqualTo: endDate)
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
