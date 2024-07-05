import 'package:dashboard/models/fortnightly_qouta_percentage.dart';
import 'package:dashboard/views/widgets/fortnight_breakdown.dart';
import 'package:flutter/material.dart';

class FornightlyBreakdown extends StatelessWidget {
  const FornightlyBreakdown({
    super.key,
    required this.fortnightlyQoutaPercentages,
  });
  final List<FortnightlyQoutaPercentage> fortnightlyQoutaPercentages;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        for (FortnightlyQoutaPercentage fortnightlyQoutaPercent
            in fortnightlyQoutaPercentages)
          FortnightBreakdown(fortnightlyQoutaPercent: fortnightlyQoutaPercent),
      ],
    );
  }
}
