import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_provider.g.dart';

@riverpod
Stream<Booking> booking(BookingRef ref, String id) async* {
  final db = FirebaseFirestore.instance;
  final doc = db.collection('bookings').doc(id);
  yield* doc.snapshots().map((snapshot) => Booking.fromDocSnapshot(snapshot));
}
