import 'package:dashboard/models/fortnight.dart';

class FortnightlyQoutaPercentage {
  final Fortnight fortnight;
  final double qoutaPercentage;

  FortnightlyQoutaPercentage({
    required this.fortnight,
    required this.qoutaPercentage,
  });

  factory FortnightlyQoutaPercentage.fromJson(Map<String, dynamic> json) {
    return FortnightlyQoutaPercentage(
      fortnight: Fortnight.fromJson(json['fortnight']),
      qoutaPercentage: json['qoutaPercentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fortnight': fortnight.toJson(),
      'qoutaPercentage': qoutaPercentage,
    };
  }
}
