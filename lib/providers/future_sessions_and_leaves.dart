import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/future_sessions_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'leaves_provider.dart';

part 'future_sessions_and_leaves.g.dart';

@riverpod
Stream<Map<String, List>> futureSessionsAndLeaves(
    FutureSessionsAndLeavesRef ref, String uid) async* {
  final List<Session> sessions =
      await ref.watch(futureSessionsProvider(coachUid: uid).future);
  final List<Leave> leaves = await ref.watch(leavesProvider([uid].lock).future);
  final List<Leave> upcomingLeaves = leaves
      .where((leave) =>
          leave.status == LeaveStatus.approved ||
          leave.status == LeaveStatus.pending)
      .toList();

  yield {
    'sessions': sessions,
    'leaves': upcomingLeaves,
  };
}
