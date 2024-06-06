import 'package:dashboard/models/screen_item.dart';
import 'package:dashboard/providers/auth.dart';
import 'package:dashboard/providers/navigation.dart';
import 'package:dashboard/views/screens/admin_tools/admin_tools.dart';
import 'package:dashboard/views/screens/login_screen.dart';
import 'package:dashboard/views/screens/my_calendar.dart';
import 'package:dashboard/views/screens/navigation_shell.dart';
import 'package:dashboard/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
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
      path: '/adminTools/createManualBooking',
      builder: (context, state) {
        return const Placeholder();
      },
    ),
    ShellRoute(
      routes: [
        GoRoute(
          path: '/adminTools/createManualBooking/type',
          builder: (context, state) {
            return const Placeholder();
          },
        ),
        GoRoute(
          path: '/adminTools/createManualBooking/info',
          builder: (context, state) {
            return const Placeholder();
          },
        ),
        GoRoute(
          path: '/adminTools/createManualBooking/date',
          builder: (context, state) {
            return const Placeholder();
          },
        ),
        GoRoute(
          path: '/adminTools/createManualBooking/coach',
          builder: (context, state) {
            return const Placeholder();
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
});
