import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/auth_provider.dart';
import 'package:dashboard/providers/bookings_provider.dart';
import 'package:dashboard/providers/coaches_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_calendar_provider.g.dart';

@riverpod
Stream<List<Booking>> myCalendar(MyCalendarRef ref) async* {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = await ref.watch(authProvider.future);

  if (user == null) {
    yield [];
  }
  final currentCoach = await ref.watch(coachProvider(user!.uid).future);
  final IList<Coach> prop = [currentCoach].lock;
  final List<Booking> bookings = await ref.watch(bookingsProvider(prop).future);
  yield bookings;
}
