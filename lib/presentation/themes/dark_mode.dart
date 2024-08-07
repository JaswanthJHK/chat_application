import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark( // previously instead of dark there was right i just changed if there is any color problem  just change this to light
    primaryContainer: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    primaryFixed: Colors.grey[900], // other user chat color
    primaryFixedDim: Colors.grey.shade900,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey[800],
    tertiaryContainer: Colors.grey.shade100,
    secondaryContainer: Colors.grey[700],
    inversePrimary: Colors.grey[300],
    shadow: Colors.grey[700],
  ),
);
