import 'package:cloud_functions/cloud_functions.dart';
import 'package:dashboard/firebase_options.dart';
import 'package:dashboard/providers/current_coach_provider.dart';
import 'package:dashboard/router.dart';
import 'package:dashboard/views/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:loader_overlay/loader_overlay.dart';

const bool useEmulator = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SplashScreen(),
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _connectToFirebaseEmulator();
  await dotenv.load(fileName: '.env');
  FirebaseUIAuth.configureProviders([
    GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID']!),
  ]);
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

Future _connectToFirebaseEmulator() async {
  if (useEmulator) {
    const localHostString = 'localhost';
    FirebaseFunctions.instance.useFunctionsEmulator(localHostString, 5001);
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return EagerInitialization(
      child: GlobalLoaderOverlay(
        child: SafeArea(
          child: MaterialApp.router(
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: GoTransitions.cupertino,
                  TargetPlatform.iOS: GoTransitions.cupertino,
                  TargetPlatform.macOS: GoTransitions.cupertino,
                  TargetPlatform.windows: GoTransitions.cupertino,
                },
              ),
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.lightBlue,
                brightness: Brightness.light,
              ),
            ),
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}

class EagerInitialization extends ConsumerWidget {
  const EagerInitialization({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialize providers by watching them.
    // By using "watch", the provider will stay alive and not be disposed.
    ref.watch(currentCoachProvider);
    return child;
  }
}
