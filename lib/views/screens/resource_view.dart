import 'package:dashboard/providers/resource_calendar_source_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ResourceView extends ConsumerWidget {
  const ResourceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = ref.watch(resourceCalendarSourceProvider);
    final resourceController = CalendarController();
    return source.when(
      data: (source) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: SfCalendar(
              controller: resourceController,
              view: CalendarView.timelineMonth,
              dataSource: source,
              allowViewNavigation: true,
              allowAppointmentResize: false,
              allowDragAndDrop: false,
              showDatePickerButton: true,
              onTap: (calendarTapDetails) {
                Appointment appointment = calendarTapDetails.appointments![0];
                String? bookingId = appointment.location;
                if (bookingId != null) {
                  context.go('/adminTools/manageBookings/$bookingId');
                }
              },
              allowedViews: const [
                CalendarView.timelineDay,
                CalendarView.timelineWeek,
                CalendarView.timelineWorkWeek,
                CalendarView.timelineMonth,
              ],
              resourceViewSettings: ResourceViewSettings(
                showAvatar: false,
                visibleResourceCount: source.resources!.length,
              ),
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error, $stackTrace'),
      ),
    );
  }
}
