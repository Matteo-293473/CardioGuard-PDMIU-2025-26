import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/providers.dart';
import 'theme/app_theme.dart';
import 'home_screen.dart';

import 'app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences: ottenere l'istanza è ASYNC (getInstance() ritorna Future).
  // Lo facciamo qui UNA VOLTA sola, prima di runApp, così il resto dell'app può usarla in modo "sincrono".
  final prefs = await SharedPreferences.getInstance();

  runApp(
    // ProviderScope è la "radice" di Riverpod.
    ProviderScope(
      overrides: [
        // qui "iniettiamo" l'istanza di SharedPreferences dentro Riverpod.
        // sharedPreferencesProvider nel codice diventa: "usa QUESTO prefs già pronto".
        // Risultato: tutti i provider che dipendono da sharedPreferencesProvider non devono più fare getInstance().
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
    // da qui in poi, l'app può leggere SharedPreferences tramite i provider/repository
    // senza gestire "loading" solo per inizializzarle (perché le prefs sono già pronte).
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'CardioGuard',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode, // se il tema cambia, MaterialApp viene ri-renderizzato
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        
        // zoom su tutto per riempire lo spazio dello schermo se > breakpoint
        final realWidth = mediaQuery.size.width;

        // se si supera il breakpoint, allora zoomiamo
        if (realWidth > AppConstants.bigScreenBreakpoint) {
           final scaleFactor = realWidth / AppConstants.bigScreenBreakpoint;
           
           // calcolo la nuova altezza per mantenere l'aspect ratio
           final newHeight = mediaQuery.size.height / scaleFactor;
           
           return FittedBox(
             fit: BoxFit.contain,
             alignment: Alignment.topCenter,
             child: SizedBox(
               width: AppConstants.bigScreenBreakpoint,
               height: newHeight,
               child: MediaQuery(
                 data: mediaQuery.copyWith(
                   // aumento il dpr per mantenere i testi nitidi anche se zoomato
                   devicePixelRatio: mediaQuery.devicePixelRatio * scaleFactor,
                   // Reset del textScaler perché lo zoom lo fa già il FittedBox
                   textScaler: TextScaler.noScaling,
                 ),
                 child: child!,
               ),
             ),
           );
        }

        // caso smartphone, no zoom 
        return child!;
      },
      home: const MyHomePage(),
    );
  }
}
