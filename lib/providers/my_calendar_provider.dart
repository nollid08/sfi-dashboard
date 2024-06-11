import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/providers/auth_provider.dart';
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

  final String uid = user!.uid;
  final Stream<QuerySnapshot> bookingSnapshots = db
      .collection('bookings')
      .where('coachIds', arrayContains: uid)
      .snapshots();
  yield* bookingSnapshots.map((snapshot) {
    return snapshot.docs.map((doc) {
      return Booking.fromQueryDocSnapshot(doc);
    }).toList();
  });
}
