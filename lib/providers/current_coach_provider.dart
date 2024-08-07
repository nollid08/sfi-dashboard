import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/auth_provider.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_coach_provider.g.dart';

@riverpod
Stream<Coach?> currentCoach(CurrentCoachRef ref) async* {
  final User? user = await ref.watch(authProvider.future);

  if (user == null) {
    yield null;
  }

  final Coach coach = await ref.watch(coachProvider(user?.uid ?? '').future);

  yield coach;
}
