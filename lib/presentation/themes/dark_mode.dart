import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.light(
    primaryContainer: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    onPrimary: Colors.black54, // other user chat color
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey[800],
    secondaryContainer: const Color.fromARGB(255, 232, 232, 232),
    inversePrimary: Colors.grey[300],

  ),
);
