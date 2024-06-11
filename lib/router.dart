import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/providers/auth_provider.dart';
import 'package:dashboard/views/screens/admin_tools/manage_activities.dart';
import 'package:dashboard/views/screens/admin_tools/admin_tools.dart';
import 'package:dashboard/views/screens/admin_tools/manage_clients.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/gather_info_screen.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/manual_booking_shell.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/select_coaches.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/select_dates.dart';
import 'package:dashboard/views/screens/login_screen.dart';
import 'package:dashboard/views/screens/my_calendar.dart';
import 'package:dashboard/views/screens/navigation_shell.dart';
import 'package:dashboard/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authProvider);
  final List<RouteBase> mainScreens = [
    GoRoute(
      path: '/myCalendar',
      builder: (context, state) {
        return const MyCalendar();
      },
    ),
    GoRoute(
      path: '/myProfile',
      builder: (context, state) {
        return const Placeholder();
      },
    ),
    GoRoute(
      path: '/mySettings',
      builder: (context, state) {
        return const Placeholder();
      },
    ),
    GoRoute(
      path: '/adminTools',
      builder: (context, state) {
        return const AdminTools();
      },
    ),
    GoRoute(
      path: '/adminTools/manageCoaches',
      builder: (context, state) {
        return const Placeholder();
      },
    ),
    GoRoute(
      path: '/adminTools/manageActivities',
      builder: (context, state) {
        return const Activities();
      },
    ),
    GoRoute(
      path: '/adminTools/manageClients',
      builder: (context, state) {
        return const ManageSchools();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ManualBookingShell(child);
      },
      routes: [
        GoRoute(
          path: '/adminTools/createManualBooking',
          builder: (context, state) {
            return const GatherBookingInfo();
          },
        ),
        GoRoute(
          path: '/adminTools/createManualBooking/date',
          builder: (context, state) {
            if (state.extra == null) return const GatherBookingInfo();
            Map<String, dynamic> selections =
                state.extra as Map<String, dynamic>;
            final Activity selectedActivity =
                selections['activity'] as Activity;
            final selectedClient = selections['client'] as Client;

            return SelectDatesScreen(
              selectedActivity: selectedActivity,
              selectedClient: selectedClient,
            );
          },
        ),
        GoRoute(
          path: '/adminTools/createManualBooking/coach',
          builder: (context, state) {
            Booking? booking = state.extra as Booking?;
            booking ??= Booking(
              id: '123',
              activityId: '123',
              clientId: '123',
              coachIds: [],
              startDateTime: DateTime.now(),
              endTime: const TimeOfDay(hour: 0, minute: 0),
            );
            return SelectCoachesScreen(booking);
          },
        ),
        GoRoute(
          path: '/adminTools/createManualBooking/success',
          builder: (context, state) {
            return const Placeholder();
          },
        ),
      ],
    ),
  ];
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return NavigationShell(child: child);
        },
        routes: mainScreens,
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
    ],
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (authState.isLoading || authState.hasError) return null;

      // Here we guarantee that hasData == true, i.e. we have a readable value

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authState.valueOrNull != null;

      final isSplash = state.uri.path == '/splash';
      if (isSplash) {
        return isAuth ? '/myCalendar' : '/login';
      }

      final isLoggingIn = state.uri.path == '/login';
      if (isLoggingIn) return isAuth ? '/myCalendar' : null;

      return isAuth ? null : '/splash';
    },
  );
}
