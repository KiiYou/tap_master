import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const TapMasterApp());
}

class TapMasterApp extends StatelessWidget {
  const TapMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF4D6BFF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tap Master',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
          surface: const Color(0xFF101A34),
        ),
        scaffoldBackgroundColor: const Color(0xFF070B18),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
