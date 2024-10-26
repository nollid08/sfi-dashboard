import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_future_bookings.g.dart';

@riverpod
Stream<List<Booking>> myFutureBookings(MyFutureBookingsRef ref) async* {
  final user = await ref.watch(authProvider.future);

  if (user != null) {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> bookingSnapshots = db
        .collection('bookings')
        .where('coaches', arrayContains: user.uid)
        .where('endDate', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots();
    yield* bookingSnapshots.map((QuerySnapshot<Object?> snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromQueryDocSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }
}
