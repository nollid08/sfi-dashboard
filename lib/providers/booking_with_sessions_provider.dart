import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/models/session.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:dashboard/providers/single_booking_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_with_sessions_provider.g.dart';

@riverpod
class SingleBookingWithSessions extends _$SingleBookingWithSessions {
  @override
  Stream<BookingWithSessions> build(String id) async* {
    final booking = await ref.watch(singleBookingProvider(id).future);
    final sessions =
        await ref.watch(sessionsProvider(bookingIds: [id].lock).future);

    yield BookingWithSessions.fromBase(booking, sessions);
  }
}
