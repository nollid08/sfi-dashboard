int inclusiveDaysBetween(DateTime startDate, DateTime endDate) {
  // Ensure start date is before end date
  if (startDate.isAfter(endDate)) {
    throw ArgumentError('Start date must be before end date');
  }

  // Calculate the difference in days without considering time
  int daysDifference = endDate.difference(startDate).inDays;

  // Handle cases where the end time is before the start time
  if (endDate.hour < startDate.hour ||
      (endDate.hour == startDate.hour && endDate.minute < startDate.minute)) {
    daysDifference--;
  }

  return daysDifference + 1; // Inclusive, so add 1
}
