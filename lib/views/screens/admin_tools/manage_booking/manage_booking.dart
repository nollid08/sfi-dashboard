import 'package:flutter/material.dart';

class ManageBooking extends StatelessWidget {
  final String id;

  const ManageBooking({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Manage Booking with id: $id');
  }
}
