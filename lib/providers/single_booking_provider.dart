import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'single_booking_provider.g.dart';

@riverpod
class SingleBooking extends _$SingleBooking {
  @override
  Stream<Booking> build(String id) async* {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final Stream<DocumentSnapshot<Map<String, dynamic>>> bookingSnapshot =
        db.collection('bookings').doc(id).snapshots();

    await for (final DocumentSnapshot<Map<String, dynamic>> snapshot
        in bookingSnapshot) {
      yield Booking.fromDocSnapshot(snapshot);
    }
  }
}
