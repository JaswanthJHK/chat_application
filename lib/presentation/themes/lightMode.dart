import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primaryContainer: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    tertiaryContainer:
        const Color.fromARGB(255, 82, 81, 79), // other user chat color
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    secondaryContainer: Colors.grey.shade900,
    inversePrimary: const Color.fromARGB(255, 58, 164, 250),
  ),
);
