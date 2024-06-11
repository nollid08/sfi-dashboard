import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// final authProvider = StreamProvider<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges();
// });

part 'auth_provider.g.dart';

@riverpod
Stream<User?> auth(AuthRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}
