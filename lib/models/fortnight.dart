class Fortnight {
  final int index;
  final DateTime startDate;
  final DateTime endDate;

  Fortnight({
    required this.index,
    required this.startDate,
    required this.endDate,
  });

  factory Fortnight.fromIndex(int index) {
    final DateTime baseDate = DateTime(2024, 0, 1);
    final startDate = baseDate.add(Duration(days: (index - 1) * 14));
    final endDate = startDate.add(const Duration(days: 13));
    return Fortnight(index: index, startDate: startDate, endDate: endDate);
  }

  factory Fortnight.fromDate(DateTime givenDate) {
    final DateTime baseStartDate =
        DateTime(2024, 0, 1); // Start date of FN1 is January 1, 2024

    // Calculate the difference in days
    const millisecondsPerDay = 1000 * 60 * 60 * 24;
    final deltaDays = ((givenDate.millisecondsSinceEpoch -
                baseStartDate.millisecondsSinceEpoch) /
            millisecondsPerDay)
        .floor();

    // Calculate FN period
    final fnPeriod = (deltaDays / 14).floor() + 1;
    return Fortnight.fromIndex(fnPeriod);
  }

  static List<Fortnight> fromRange(DateTime start, DateTime end) {
    final fortnights = <Fortnight>[];
    var current = DateTime(start.year, start.month, start.day);
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      final fortnight = Fortnight.fromDate(current);
      if (!fortnights.contains(fortnight)) {
        fortnights.add(fortnight);
      }
      current = current.add(const Duration(days: 1));
    }
    return fortnights;
  }

  factory Fortnight.fromJson(Map<String, dynamic> json) {
    return Fortnight.fromIndex(json['index']);
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
