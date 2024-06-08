import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/client.dart';
import 'package:flutter/material.dart';

class SelectDatesScreen extends StatelessWidget {
  final Activity selectedActivity;
  final Client selectedClient;
  const SelectDatesScreen({
    super.key,
    required this.selectedActivity,
    required this.selectedClient,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        'Current information: Activity: ${selectedActivity.name}, Client: ${selectedClient.name}');
  }
}
