import 'package:dashboard/models/resource_calendar_source.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resource_calendar_source_provider.g.dart';

@riverpod
Stream<ResourceCalendarDataSource> resourceCalendarSource(
    ResourceCalendarSourceRef ref) async* {
  final coaches = await ref.watch(coachesProvider.future);
  final sessions = await ref.watch(sessionsProvider().future);

  yield ResourceCalendarDataSource.fromData(
    sessions: sessions,
    coaches: coaches,
  );
}
