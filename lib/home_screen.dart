// schermata principale dell'applicazione
import 'package:flutter/material.dart';
import 'app_constants.dart';
import 'settings_screen.dart';
import 'widgets/home/air_quality_widget.dart';
import 'widgets/home/home_drawer.dart';
import 'widgets/home/heartbeat_logo.dart';
import 'widgets/home/home_greeting.dart';
import 'widgets/home/home_buttons.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final isLarge = mediaQuery.size.width > AppConstants.bigScreenBreakpoint;
    final isLandscapeMobile = !isPortrait && !isLarge;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CardioGuard'),
        actions: [
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
      drawer: const HomeDrawer(),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: isLandscapeMobile ? 10 : 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // sezione logo
              HeartbeatLogo(
                height: (mediaQuery.size.height * 0.15).clamp(80.0, 200.0),
              ),
              
              const SizedBox(height: 8),

              // sezione scritta benvenuto personalizzata
              const HomeGreeting(),
              
              SizedBox(height: isLandscapeMobile ? 16 : 40),
              
              // sezione dedicata API - aria ambiente+geocoding
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AirQualityWidget(),
                  ],
                ),
              ),
              
              SizedBox(height: isLandscapeMobile ? 12 : 32),
              
              // azioni rapide - Le mie misurazioni e Analisi AI
              const HomeButtons(),
              
              SizedBox(height: isLandscapeMobile ? 20 : 50),

              // footer
              Text(
                'Uniurb Informatica e Innovazione Digitale 2025-2026',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
