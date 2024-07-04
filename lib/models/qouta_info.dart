import 'package:dashboard/models/fortnightly_qouta_percentage.dart';

class QoutaInfo {

    final double currentAverageQoutaPercentage;
    final double projectedQoutaPercentage;
    final List<FortnightlyQoutaPercentage> currentFortnightlyQoutaPercentages;
    final List<FortnightlyQoutaPercentage> projectedFortnightlyQoutaPercentages;

    QoutaInfo({
        required this.currentAverageQoutaPercentage,
        required this.projectedQoutaPercentage,
        required this.currentFortnightlyQoutaPercentages,
        required this.projectedFortnightlyQoutaPercentages,
    });

    factory QoutaInfo.fromJson( json) {
        print('QoutaInfo.fromJson: $json');
        
        return QoutaInfo(
            currentAverageQoutaPercentage: json['currentAverageQoutaPercentage'],
            projectedQoutaPercentage: json['projectedQoutaPercentage'],
            currentFortnightlyQoutaPercentages: json['currentFortnightlyQoutaPercentages'].map<FortnightlyQoutaPercentage>((json) => FortnightlyQoutaPercentage.fromJson(json)).toList(),
            projectedFortnightlyQoutaPercentages: json['projectedFortnightlyQoutaPercentages'].map<FortnightlyQoutaPercentage>((json) => FortnightlyQoutaPercentage.fromJson(json)).toList(),
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'currentAverageQoutaPercentage': currentAverageQoutaPercentage,
            'projectedQoutaPercentage': projectedQoutaPercentage,
            'currentFortnightlyQoutaPercentages': currentFortnightlyQoutaPercentages.map((e) => e.toJson()).toList(),
            'projectedFortnightlyQoutaPercentages': projectedFortnightlyQoutaPercentages.map((e) => e.toJson()).toList(),
        };
    }
}