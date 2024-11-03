import 'package:dashboard/models/activity.dart';
import 'package:dashboard/models/booking_template.dart';
import 'package:dashboard/models/client.dart';
import 'package:dashboard/models/coach.dart';
import 'package:dashboard/providers/auth_provider.dart';
import 'package:dashboard/providers/current_coach_provider.dart';
import 'package:dashboard/providers/is_wide_screen_provider.dart';
import 'package:dashboard/providers/navigation/indexed_screens_provider.dart';
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
import 'package:dashboard/views/screens/mobile_booking_info.dart';
import 'package:dashboard/views/screens/my_bookings.dart';
import 'package:dashboard/views/screens/login_screen.dart';
import 'package:dashboard/views/screens/desktop_booking_shell.dart';
import 'package:dashboard/views/screens/my_calendar.dart';
import 'package:dashboard/views/screens/my_leave_screen.dart';
import 'package:dashboard/views/screens/navigation_shell.dart';
import 'package:dashboard/views/screens/resource_view.dart';
import 'package:dashboard/views/screens/splash_screen.dart';
import 'package:dashboard/views/screens/view_booking.dart';
import 'package:dashboard/views/screens/view_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authProvider);

  // private navigators
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
  final shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');

// the one and only GoRouter instance
  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: rootNavigatorKey,
    routes: [
      // Stateful nested navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          Future(() {
            int currentIndex = ref.read(selectedScreenIndexProvider);
            ref
                .read(selectedScreenIndexProvider.notifier)
                .updateIndexBasedOnRouteName(state.uri.path, currentIndex);
          });
          return NavigationShell(child: navigationShell);
        },
        branches: [
          // first branch (A)
          StatefulShellBranch(
            navigatorKey: shellNavigatorAKey,
            initialLocation: '/myLeave',
            routes: [
              GoRoute(
                path: '/myCalendar',
                builder: (context, state) {
                  return const MyCalendar();
                },
              ),
              GoRoute(
                path: '/myPastBookings',
                builder: (context, state) {
                  return const MyBookingsView(
                    bookingsToDisplay: BookingsToDisplay.past,
                  );
                },
              ),
              GoRoute(
                path: '/myFutureBookings',
                builder: (context, state) {
                  return const MyBookingsView(
                    bookingsToDisplay: BookingsToDisplay.future,
                  );
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
                  final int? sessionIndex =
                      state.pathParameters['sessionIndex'] != null
                          ? int.parse(state.pathParameters['sessionIndex']!)
                          : null;
                  return DesktopBookingShell(
                    bookingId: bookingId,
                    sessionIndex: sessionIndex,
                    child: child,
                  );
                },
                redirect: (context, state) {
                  final bool isWideScreen =
                      ref.watch(isWideScreenProvider(MediaQuery.of(context)));
                  if (!isWideScreen) {
                    return '/myBookings/mobile/${state.pathParameters['bookingId']}';
                  }
                  return null;
                },
                routes: [
                  GoRoute(
                    path: '/myBookings/:bookingId',
                    builder: (context, state) {
                      final bookingId = state.pathParameters['bookingId']!;
                      return ViewBookingInfo(id: bookingId);
                    },
                  ),
                  GoRoute(
                    path: '/myBookings/:bookingId/sessions/:sessionIndex',
                    builder: (context, state) {
                      final bookingId = state.pathParameters['bookingId']!;
                      if (state.pathParameters['sessionIndex'] == '') {
                        return ViewBookingInfo(id: bookingId);
                      }
                      final int sessionIndex = int.parse(
                          state.pathParameters['sessionIndex'] ?? "-1");
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
                path: '/myBookings/mobile/:bookingId',
                builder: (context, state) {
                  return MobileBookingOverview(
                    bookingId: state.pathParameters['bookingId']!,
                  );
                },
                redirect: (context, state) {
                  final bool isWideScreen =
                      ref.watch(isWideScreenProvider(MediaQuery.of(context)));
                  if (isWideScreen) {
                    return '/myBookings/${state.pathParameters['bookingId']}';
                  }
                  return null;
                },
              ),
              // GoRoute(
              //   path: '/myBookings/booking/:bookingId',
              //   builder: (context, state) {
              //     final bookingId = state.pathParameters['bookingId']!;
              //     return ViewMobileBooking(id: bookingId);
              //   },
              // ),
              GoRoute(
                path: '/myBookings/booking/:bookingId/sessions/:sessionIndex',
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
              GoRoute(
                path: '/adminTools',
                builder: (context, state) {
                  return const AdminTools();
                },
                redirect: (context, state) async {
                  final Coach? coach =
                      await ref.watch(currentCoachProvider.future);
                  final isAdmin = coach?.isAdmin ?? false;
                  return isAdmin ? null : '/myCalendar';
                },
              ),
              GoRoute(
                path: '/adminTools/manageCoaches',
                builder: (context, state) {
                  return const ManageCoachesScreen();
                },
                redirect: (context, state) async {
                  final Coach? coach =
                      await ref.watch(currentCoachProvider.future);
                  final isAdmin = coach?.isAdmin ?? false;
                  return isAdmin ? null : '/myCalendar';
                },
              ),
              GoRoute(
                path: '/adminTools/manageActivities',
                builder: (context, state) {
                  return const Activities();
                },
                redirect: (context, state) async {
                  final Coach? coach =
                      await ref.watch(currentCoachProvider.future);
                  final isAdmin = coach?.isAdmin ?? false;
                  return isAdmin ? null : '/myCalendar';
                },
              ),
              GoRoute(
                path: '/adminTools/resourceView',
                builder: (context, state) {
                  return const ResourceView();
                },
                redirect: (context, state) async {
                  final Coach? coach =
                      await ref.watch(currentCoachProvider.future);
                  final isAdmin = coach?.isAdmin ?? false;
                  return isAdmin ? null : '/myCalendar';
                },
              ),
              GoRoute(
                  path: '/adminTools/manageClients',
                  builder: (context, state) {
                    return const ManageSchools();
                  },
                  redirect: (context, state) async {
                    final Coach? coach =
                        await ref.watch(currentCoachProvider.future);
                    final isAdmin = coach?.isAdmin ?? false;
                    return isAdmin ? null : '/myCalendar';
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
                redirect: (context, state) async {
                  final Coach? coach =
                      await ref.watch(currentCoachProvider.future);
                  final isAdmin = coach?.isAdmin ?? false;
                  return isAdmin ? null : '/myCalendar';
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
                      if (state.extra == null) {
                        return '/adminTools/createManualBooking';
                      }
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
                          final int sessionIndex = int.parse(
                              state.pathParameters['sessionIndex'] ?? "-1");
                          return ManageSession(
                            key: ValueKey(sessionIndex),
                            bookingId: bookingId,
                            sessionIndex: sessionIndex,
                          );
                        },
                      ),
                      GoRoute(
                        path:
                            '/adminTools/manageBookings/:bookingId/addSession',
                        builder: (context, state) {
                          final bookingId = state.pathParameters['bookingId']!;
                          return AddBookingSession(bookingId: bookingId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorBKey,
            initialLocation: '/myBCalendar',
            routes: [
              GoRoute(
                path: '/myBCalendar',
                builder: (context, state) {
                  return const MyCalendar();
                },
              ),
            ],
          ),
        ],
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
      print('Currently On to ${state.uri}, ${state.fullPath}');
      int currentIndex = ref.read(selectedScreenIndexProvider);
      Future(() {
        ref
            .read(selectedScreenIndexProvider.notifier)
            .updateIndexBasedOnRouteName(state.uri.path, currentIndex);
      });
      // If our async state is loading, don't perform redirects, yet
      if (authState.isLoading || authState.hasError) return null;

      // Here we guarantee that hasData == true, i.e. we have a readable value

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authState.valueOrNull != null;

      final isSplash = state.uri.path == '/splash';
      if (isSplash) {
        if (isAuth) {
          print('Auth, Splash -> Redirect To MyCalendar');
          return '/myCalendar';
        } else {
          print('No Auth, Splash -> Redirect To Login');
          return '/login';
        }
      }
      final isLoginScreen = state.uri.path == '/login';

      if (isLoginScreen) {
        if (isAuth) {
          print('Auth, Login -> Redirect To MyCalendar');
          return '/myCalendar';
        } else {
          print('No Auth, Login -> No Redirect');
          return null;
        }
      }
      if (!isSplash && !isLoginScreen) {
        if (isAuth) {
          print('Auth, Standard Screen -> No Redirect');
          return null;
        } else {
          print('No Auth, Standard Screen -> Redirect To Splash');
          return '/splash';
        }
      }
      return null;
    },
  );
}
