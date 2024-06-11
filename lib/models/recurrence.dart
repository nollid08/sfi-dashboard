class EventRecurrenceInfo {
  final int interval;
  final DateTime startDate;
  final DateTime endDate;

  EventRecurrenceInfo(
      {required this.interval, required this.startDate, required this.endDate});
}

class DailyRecurrence extends EventRecurrenceInfo {
  DailyRecurrence(
      {required super.interval,
      required super.startDate,
      required super.endDate});
}

class WeeklyRecurrence extends EventRecurrenceInfo {
  final List<int> days;

  WeeklyRecurrence(
      {required this.days,
      required super.interval,
      required super.startDate,
      required super.endDate});
}

class MonthlyRecurrence extends EventRecurrenceInfo {
  final List<int> dayOfMonth;

  MonthlyRecurrence(
      {required this.dayOfMonth,
      required super.interval,
      required super.startDate,
      required super.endDate});
}
