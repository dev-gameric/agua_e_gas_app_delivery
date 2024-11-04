import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
        fontFamily: 'Nunito Sans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      );
}
