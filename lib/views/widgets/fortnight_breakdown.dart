import 'package:dashboard/models/fortnightly_qouta_percentage.dart';
import 'package:flutter/material.dart';

class FortnightBreakdown extends StatelessWidget {
  const FortnightBreakdown({
    super.key,
    required this.fortnightlyQoutaPercent,
  });

  final FortnightlyQoutaPercentage fortnightlyQoutaPercent;

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = fortnightlyQoutaPercent.qoutaPercentage > 1
        ? Colors.green
        : fortnightlyQoutaPercent.qoutaPercentage > 0.6
            ? Colors.yellow
            : fortnightlyQoutaPercent.qoutaPercentage > 0.3
                ? Colors.orange[400]!
                : fortnightlyQoutaPercent.qoutaPercentage > 0.2
                    ? Colors.orange[700]!
                    : Colors.red;

    return Card(
      surfaceTintColor: indicatorColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: indicatorColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'FN${fortnightlyQoutaPercent.fortnight.index}',
              ),
              Text(
                '${(fortnightlyQoutaPercent.qoutaPercentage * 100).floor()}%',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
