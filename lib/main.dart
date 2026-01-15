import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'providers/providers.dart';
import 'services/notification_service.dart';
import 'settings_screen.dart';
import 'diagnosis_screen.dart';
import 'measurements_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inizializziamo il database per Windows/Linux
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Inizializziamo il servizio di notifiche
  await NotificationService().init();

  // 1. Inizializziamo SharedPreferences prima di avviare l'app
  final prefs = await SharedPreferences.getInstance();

  runApp(
    // 2. Usiamo overrides per passare le prefs al provider
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ascoltiamo lo stato del tema (ThemeMode) dal nuovo provider
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'CardioGuard',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Analisi IA',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DiagnosisScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Image.asset(
                    'assets/images/logo.png',
                    height: isPortrait ? 120 : 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Benvenuto in CardioGuard!',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Layout flessibile per i bottoni
                  if (isPortrait)
                    Column(
                      children: [
                        _buildHomeButton(
                          context,
                          'Le mie Misurazioni',
                          Icons.monitor_heart_outlined,
                          Colors.blue,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const MeasurementsScreen()),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildHomeButton(
                          context,
                          'Check Salute Cuore',
                          Icons.analytics_outlined,
                          Colors.red,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const DiagnosisScreen()),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHomeButton(
                          context,
                          'Misurazioni',
                          Icons.monitor_heart_outlined,
                          Colors.blue,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const MeasurementsScreen()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildHomeButton(
                          context,
                          'Check IA',
                          Icons.analytics_outlined,
                          Colors.red,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const DiagnosisScreen()),
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 32),
                  const Text('Vai nelle impostazioni per gestire il profilo.'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 220, // leggermente ridotto per orizzontale
      height: 60,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

}
