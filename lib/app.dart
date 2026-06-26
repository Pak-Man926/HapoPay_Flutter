import 'package:flutter/material.dart';
import 'package:hapo_pay/landing_screen.dart';

class HapoPayApp extends StatelessWidget {
  const HapoPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HapoPay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HapoPayLandingScreen(),
    );
  }
}