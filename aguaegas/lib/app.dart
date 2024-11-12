import 'package:aguaegas/core/theme/app_theme.dart';
import 'package:aguaegas/screens/inicial/incial.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      title: 'Água e Gás',
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
