import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/models/session.dart';
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
        .where('coachUids',
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
    if (booking.isCustom) {
      throw Exception('Custom bookings Must Yet Be Implemented');
    }
    //If Booking Repeats, then generate all the sessions

    await db.collection('bookings').doc(booking.id).set(booking.toJson());
    final List<Session> sessions = booking.generateStandardSessions();
    final batch = db.batch();
    for (final session in sessions) {
      batch.set(db.collection('sessions').doc(), session.toJson());
    }
    await batch.commit();
  }
}
