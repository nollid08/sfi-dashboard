import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/coach_calendar_source.dart';
import 'package:dashboard/models/resource_calendar_source.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:dashboard/providers/leaves_provider.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resource_calendar_source_provider.g.dart';

@riverpod
Stream<ResourceCalendarDataSource> resourceCalendarSource(
    ResourceCalendarSourceRef ref) async* {
  final coaches = await ref.watch(coachesProvider.future);
  final sessions = await ref.read(sessionsProvider().future);
  final leaves = await ref.read(leavesProvider(<String>[].lock).future);

  yield ResourceCalendarDataSource.fromData(
    sessions: sessions,
    coaches: coaches,
    leaves: leaves,
  );
}
