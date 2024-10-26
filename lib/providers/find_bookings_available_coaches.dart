import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/booking_template.dart';
import 'package:dashboard/models/coach_recommendation.dart';
import 'package:dashboard/providers/find_booking_templates_available_coaches.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_bookings_available_coaches.g.dart';

@riverpod
Future<List<CoachRecommendation>> findBookingsAvailableCoaches(
    FindBookingsAvailableCoachesRef ref, String bookingId) async {
  final db = FirebaseFirestore.instance;
  final bookingDoc = await db.collection('bookings').doc(bookingId).get();
  if (!bookingDoc.exists) {
    throw Exception('Booking with id $bookingId does not exist');
  }
  final booking = Booking.fromDocSnapshot(bookingDoc);
  final bookingTemplate = await BookingTemplate.fromBooking(booking);

  final coachRecommendations = await ref.read(
      findBookingTemplatesAvailableCoachesProvider(bookingTemplate).future);
  return coachRecommendations;
}
