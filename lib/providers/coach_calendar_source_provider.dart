
import 'package:dashboard/models/coach_calendar_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coach_calendar_source_provider.g.dart';

@Riverpod(keepAlive: true)
CoachCalendarSource coachCalendarSource(CoachCalendarSourceRef ref) {
  final CoachCalendarSource source = CoachCalendarSource(
    [],
    ref: ref,
    coachUid: FirebaseAuth.instance.currentUser!.uid,
  );

  return source;
}
