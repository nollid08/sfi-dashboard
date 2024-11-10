import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart' as booking_type;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_provider.g.dart';

@riverpod
class IndividualBooking extends _$IndividualBooking {
  @override
  Stream<booking_type.Booking> build(String id) async* {
    final db = FirebaseFirestore.instance;
    final doc = db.collection('bookings').doc(id);
    yield* doc
        .snapshots()
        .map((snapshot) => booking_type.Booking.fromDocSnapshot(snapshot));
  }

  // Update Booking Notes

  Future<void> updateBookingNotes(
      {required String id, required String notes}) async {
    final db = FirebaseFirestore.instance;
    final doc = db.collection('bookings').doc(id);
    await doc.update({'notes': notes});
  }
}
