import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/booking.dart';
import 'package:dashboard/models/booking_template.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/client_types.dart';
import 'package:dashboard/providers/auth_provider.dart';
import 'package:dashboard/providers/navigation/selected_screen_index_provider.dart';
import 'package:dashboard/views/screens/admin_tools/manage_activities.dart';
import 'package:dashboard/views/screens/admin_tools/admin_tools.dart';
import 'package:dashboard/views/screens/admin_tools/manage_booking/add_booking_session.dart';
import 'package:dashboard/views/screens/admin_tools/manage_booking/manage_booking.dart';
import 'package:dashboard/views/screens/admin_tools/manage_booking/manage_booking_shell.dart';
import 'package:dashboard/views/screens/admin_tools/manage_booking/manage_bookings.dart';
import 'package:dashboard/views/screens/admin_tools/manage_client.dart';
import 'package:dashboard/views/screens/admin_tools/manage_clients.dart';
import 'package:dashboard/views/screens/admin_tools/manage_coaches.dart';
import 'package:dashboard/views/screens/admin_tools/manage_booking/manage_session.dart';
import 'package:dashboard/views/screens/admin_tools/manage_leave_requests.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/gather_info_screen.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/manual_booking_shell.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/select_coaches.dart';
import 'package:dashboard/views/screens/admin_tools/manual_booking/select_dates.dart';
import 'package:dashboard/views/screens/my_future_bookings.dart';
import 'package:dashboard/views/screens/login_screen.dart';
import 'package:dashboard/views/screens/my_booking_shell.dart';
import 'package:dashboard/views/screens/my_calendar.dart';
import 'package:dashboard/views/screens/my_leave_screen.dart';
import 'package:dashboard/views/screens/my_past_bookings.dart';
import 'package:dashboard/views/screens/navigation_shell.dart';
import 'package:dashboard/views/screens/resource_view.dart';
import 'package:dashboard/views/screens/splash_screen.dart';
import 'package:dashboard/views/screens/view_booking.dart';
import 'package:dashboard/views/screens/view_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      path: '/myFutureBookings',
      builder: (context, state) {
        return const MyFutureBookingsView();
      },
    ),
    GoRoute(
      path: '/myleave',
      builder: (context, state) {
        return const MyLeaveScreen();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        final bookingId = state.pathParameters['bookingId']!;
        final int? sessionIndex = state.pathParameters['sessionIndex'] != null
            ? int.parse(state.pathParameters['sessionIndex']!)
            : null;
        return MyBookingShell(
          bookingId: bookingId,
          sessionIndex: sessionIndex,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/myBookings/:bookingId',
          builder: (context, state) {
            final bookingId = state.pathParameters['bookingId']!;
            return ViewBooking(id: bookingId);
          },
        ),
        GoRoute(
          path: '/myBookings/:bookingId/sessions/:sessionIndex',
          builder: (context, state) {
            final bookingId = state.pathParameters['bookingId']!;
            final int sessionIndex =
                int.parse(state.pathParameters['sessionIndex'] ?? "-1");
            return ViewSession(
              key: ValueKey(sessionIndex),
              bookingId: bookingId,
              sessionIndex: sessionIndex,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/myPastBookings',
      builder: (context, state) {
        return const MyPastBookingsView();
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
        return const ManageCoachesScreen();
      },
    ),
    GoRoute(
      path: '/adminTools/manageActivities',
      builder: (context, state) {
        return const Activities();
      },
    ),
    GoRoute(
      path: '/adminTools/resourceView',
      builder: (context, state) {
        return const ResourceView();
      },
    ),
    GoRoute(
        path: '/adminTools/manageClients',
        builder: (context, state) {
          return const ManageSchools();
        },
        routes: [
          GoRoute(
            path: ':clientId',
            builder: (context, state) {
              final clientId = state.pathParameters['clientId']!;
              return ManageClient(clientId);
            },
          ),
        ]),
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
            final bookingTemplate = state.extra as BookingTemplate;
            return SelectCoachesScreen(bookingTemplate);
          },
          redirect: (context, state) {
            if (state.extra == null) return '/adminTools/createManualBooking';
            return null;
          },
        ),
        GoRoute(
            path: '/adminTools/manageLeaveRequests',
            builder: (context, state) {
              return const ManageLeaveRequests();
            }),
        GoRoute(
          path: '/adminTools/manageBookings',
          builder: (context, state) {
            return const ManageBookings();
          },
        ),
        ShellRoute(
          builder: (context, state, child) {
            final bookingId = state.pathParameters['bookingId']!;
            final int? sessionIndex =
                state.pathParameters['sessionIndex'] != null
                    ? int.parse(state.pathParameters['sessionIndex']!)
                    : null;
            final bool isAddingNewSession =
                state.fullPath?.contains('addSession') ?? false;
            return ManageBookingShell(
              bookingId: bookingId,
              sessionIndex: sessionIndex,
              isAddingNewSession: isAddingNewSession,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/adminTools/manageBookings/:bookingId',
              builder: (context, state) {
                final bookingId = state.pathParameters['bookingId']!;
                return ManageBooking(id: bookingId);
              },
            ),
            GoRoute(
              path:
                  '/adminTools/manageBookings/:bookingId/sessions/:sessionIndex',
              builder: (context, state) {
                final bookingId = state.pathParameters['bookingId']!;
                final int sessionIndex =
                    int.parse(state.pathParameters['sessionIndex'] ?? "-1");
                return ManageSession(
                  key: ValueKey(sessionIndex),
                  bookingId: bookingId,
                  sessionIndex: sessionIndex,
                );
              },
            ),
            GoRoute(
              path: '/adminTools/manageBookings/:bookingId/addSession',
              builder: (context, state) {
                final bookingId = state.pathParameters['bookingId']!;
                return AddBookingSession(bookingId: bookingId);
              },
            ),
          ],
        ),
      ],
    ),
  ];
  return GoRouter(
    initialLocation: '/splash',
    observers: [MyNavObserver()],
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

class MyNavObserver extends NavigatorObserver {
  MyNavObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    updateScreenIndex(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    updateScreenIndex(previousRoute!);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    updateScreenIndex(previousRoute!);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    updateScreenIndex(newRoute!);
  }

  void updateScreenIndex(Route<dynamic> newRoute) {
    // final container = ProviderContainer();
    // final currentRoute = newRoute.settings.name;
    // final authState = container
    //     .read(selectedScreenIndexProvider.notifier)
    //     .updateIndexBasedOnRouteName(currentRoute ?? '/');

    // container.dispose();
  }
}
