import 'package:dashboard/models/booking_template.dart';
import 'package:flutter/material.dart';

class BookingTemplateInfo extends StatelessWidget {
  const BookingTemplateInfo({
    super.key,
    required this.bookingTemplate,
  });

  final BookingTemplate bookingTemplate;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        'Current Booking',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 30,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Activity: ${bookingTemplate.activity.name}',
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        'Client: ${bookingTemplate.client.name}',
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        'Sessions No.: ${bookingTemplate.sessions.length}',
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    ]);
  }
}
