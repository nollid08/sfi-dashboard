import 'package:dashboard/firebase_options.dart';
import 'package:dashboard/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_transitions/go_transitions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: GoTransitions.cupertino,
            TargetPlatform.iOS: GoTransitions.cupertino,
            TargetPlatform.macOS: GoTransitions.cupertino,
            TargetPlatform.windows: GoTransitions.cupertino,
          },
        ),
      ),
      routerConfig: router,
    );
  }
}
