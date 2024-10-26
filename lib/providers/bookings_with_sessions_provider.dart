import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/bookings_with_sessions.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/bookings_provider.dart';
import 'package:dashboard/providers/sessions_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookings_with_sessions_provider.g.dart';

@riverpod
class BookingsWithSessions extends _$BookingsWithSessions {
  @override
  Stream<List<BookingWithSessions>> build() async* {
    final List<Booking> bookings =
        await ref.watch(bookingsProvider(<Coach>[].lock).future);
    final sessions =
        await ref.watch(sessionsProvider(bookingIds: <String>[].lock).future);

    final List<BookingWithSessions> bookingsWithSessions = [];
    for (final booking in bookings) {
      final bookingSessions = sessions
          .where((session) => session.bookingId == booking.id)
          .toList()
          .lock;
      bookingsWithSessions
          .add(BookingWithSessions.fromBase(booking, bookingSessions.unlock));
    }

    yield bookingsWithSessions;
  }
}
