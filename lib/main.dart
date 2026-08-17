import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'screens/control_gate_screen.dart';
import 'screens/view_all_screen.dart';
import 'screens/view_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    // يظهر هذا عادة عندما لا تكون إعدادات Firebase الحقيقية قد وُضعت بعد
    // في lib/firebase_options.dart. راجع README.md.
    debugPrint('تعذّر تهيئة Firebase: $e');
  }
  runApp(const NmasApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/view',
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/view'),
    GoRoute(path: '/view', builder: (context, state) => const ViewScreen()),
    GoRoute(path: '/view/all', builder: (context, state) => const ViewAllScreen()),
    GoRoute(path: '/control', builder: (context, state) => const ControlGateScreen()),
  ],
);

class NmasApp extends StatelessWidget {
  const NmasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'برنامج المخيم',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
