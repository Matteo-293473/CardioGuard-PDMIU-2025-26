import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

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
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeartbeatLogo(height: isPortrait ? 120 : 80),
              
              const SizedBox(height: 8),
              
              const HomeGreeting(),
              
              const SizedBox(height: 40),
              
              // sezione dedicata API ambiente+geocoding
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AirQualityWidget(),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // azioni rapide - Le mie misurazioni e Analisi AI
              const HomeButtons(),
              
              const SizedBox(height: 50),
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
