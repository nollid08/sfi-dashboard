import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookings_provider.g.dart';

@riverpod
class Bookings extends _$Bookings {
  @override
  Stream<List<Booking>> build(IList<Coach> coaches) async* {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> bookingSnapshots = db
        .collection('bookings')
        .where('coachIds',
            arrayContainsAny: coaches.map((coach) => coach.uid).toList())
        .snapshots();
    yield* bookingSnapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromQueryDocSnapshot(doc);
      }).toList();
    });
  }

  Future<void> addBooking(Booking booking) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('bookings').add(booking.toFBJson());
  }
}
