import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/auth_provider.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_coach_provider.g.dart';

@riverpod
Stream<Coach?> currentCoach(CurrentCoachRef ref) {
  final AsyncValue<User?> user = ref.watch(authProvider);

  user.when(
    data: (User? user) {
      if (user == null) {
        return null;
      }
      return ref.watch(coachProvider(user.uid));
    },
    loading: () {
      return null;
    },
    error: (error, stackTrace) {
      throw error;
    },
  );
  return Stream.value(null);
}
