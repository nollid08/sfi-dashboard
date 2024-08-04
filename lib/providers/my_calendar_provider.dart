import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_calendar_source.dart';
import 'package:dashboard/models/leave.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/auth_provider.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:dashboard/providers/leaves_provider.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:dashboard/providers/effective_leaves.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_calendar_provider.g.dart';

@riverpod
Stream<CoachCalendarSource> myCalendar(MyCalendarRef ref) async* {
  final User? user = await ref.watch(authProvider.future);

  if (user == null) {
    yield CoachCalendarSource([]);
  }

  final IList<String> prop = [user!.uid].lock;
  final List<Session> sessions =
      await ref.watch(sessionsProvider(coachIds: prop).future);
  final List<Leave> leaves =
      await ref.watch(effectiveLeavesProvider(user.uid).future);
  yield CoachCalendarSource.fromData(
    sessions: sessions,
    leaves: leaves,
    coachUid: user.uid,
  );
}
