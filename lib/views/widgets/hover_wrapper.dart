import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HoverWrapper extends StatefulWidget {
  final Widget child;
  final CalendarController controller;

  const HoverWrapper({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  HoverWrapperState createState() => HoverWrapperState();
}

class HoverWrapperState extends State<HoverWrapper> {
  bool _isHovering = false;
  Appointment? appointmentHovered;
  Offset hoverPosition = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        _isHovering = true;
        if (widget.controller.getCalendarDetailsAtOffset != null) {
          CalendarDetails? details = widget
              .controller.getCalendarDetailsAtOffset!(event.localPosition);
          if (details!.targetElement == CalendarElement.appointment) {
            appointmentHovered = details.appointments![0];
          }
        }
      },
      onExit: (event) => setState(() => _isHovering = false),
      child: Stack(
        children: [
          widget.child, // Your existing calendar widget
          if (_isHovering && appointmentHovered != null)
            Positioned(
              // Position the tooltip appropriately based on your calendar layout
              top: hoverPosition.dy, // Adjust as needed
              left: hoverPosition.dx, // Adjust as needed
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Tooltip background color
                  borderRadius: BorderRadius.circular(5.0), // Tooltip border
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text left
                  mainAxisSize: MainAxisSize.min, // Limit tooltip size
                  children: [
                    Text(
                      appointmentHovered!.subject.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Start Time: ${appointmentHovered?.startTime}',
                    ),
                    Text(
                      'End Time: ${appointmentHovered?.endTime}',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
