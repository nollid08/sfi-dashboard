import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/models/session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_with_sessions_provider.g.dart';

@riverpod
class SingleBookingWithSessions extends _$SingleBookingWithSessions {
  @override
  Stream<BookingWithSessions> build(String id) async* {
    final Stream<Booking> bookingStream = FirebaseFirestore.instance
        .collection('bookings')
        .doc(id)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      return Booking.fromDocSnapshot(snapshot);
    });
    final Stream<List<Session>> sessionsStream = FirebaseFirestore.instance
        .collection('sessions')
        .where('bookingId', isEqualTo: id)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        return Session.fromQueryDocSnapshot(doc);
      }).toList();
    });

    yield BookingWithSessions.fromBase(
        await bookingStream.first, await sessionsStream.first);
  }
}
