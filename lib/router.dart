import 'package:dashboard/providers/auth.dart';
import 'package:dashboard/providers/navigation.dart';
import 'package:dashboard/views/screens/login_screen.dart';
import 'package:dashboard/views/screens/navigation_shell.dart';
import 'package:dashboard/views/screens/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final screens = ref.watch(screensProvider);
  final List<GoRoute> mainScreens = [];
  for (final screen in screens) {
    mainScreens.add(
      GoRoute(
        path: screen.route,
        builder: (context, state) {
          return screen.content;
        },
      ),
    );
    if (screen.children != null) {
      for (final child in screen.children!) {
        mainScreens.add(
          GoRoute(
            path: child.route,
            builder: (context, state) {
              return child.content;
            },
          ),
        );
      }
    }
  }
  return GoRouter(
    routes: [
      ShellRoute(
          builder: (context, state, child) {
            return NavigationShell(child: child);
          },
          routes: mainScreens),
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
        return isAuth ? '/' : '/login';
      }

      final isLoggingIn = state.uri.path == '/login';
      if (isLoggingIn) return isAuth ? '/' : null;

      return isAuth ? null : '/splash';
    },
  );
});
