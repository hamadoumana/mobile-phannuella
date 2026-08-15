import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env absent (premiere execution) : ApiConstants retombe sur ses valeurs par defaut.
  }

  try {
    // Timeout defensif : si l'appareil/emulateur n'a pas de route vers les
    // serveurs Firebase (reseau d'entreprise restreint), cet appel peut
    // bloquer indefiniment et empecher runApp() de s'executer (ecran noir
    // permanent). L'app doit demarrer meme sans Firebase disponible.
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .timeout(const Duration(seconds: 8));
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (_) {
    // Firebase indisponible : l'app demarre quand meme, Crashlytics/Analytics
    // resteront simplement inactifs pour cette session.
  }

  await di.initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
