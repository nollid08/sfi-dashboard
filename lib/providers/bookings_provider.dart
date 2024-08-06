import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/booking_template.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/coach_calendar_source_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookings_provider.g.dart';

@riverpod
class Bookings extends _$Bookings {
  @override
  Stream<List<Booking>> build(IList<Coach> coaches) async* {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> bookingSnapshots = coaches.isNotEmpty
        ? db
            .collection('bookings')
            .where('coachUids',
                arrayContainsAny: coaches.map((coach) => coach.uid).toList())
            .snapshots()
        : db.collection('bookings').snapshots();
    yield* bookingSnapshots.map((QuerySnapshot<Object?> snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromQueryDocSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  Future<void> addBooking(BookingTemplate bookingTemplate) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final Booking booking = Booking.fromBookingTemplate(bookingTemplate);
    final List<Session> sessions = bookingTemplate.sessions;
    final WriteBatch batch = db.batch();
    final DocumentReference<Map<String, dynamic>> bookingRef =
        db.collection('bookings').doc(booking.id);
    batch.set(bookingRef, booking.toFBJson());
    for (final session in sessions) {
      final DocumentReference<Map<String, dynamic>> sessionRef =
          db.collection('sessions').doc();
      batch.set(sessionRef, session.toDoc());
    }
    await batch.commit();
  }
}
