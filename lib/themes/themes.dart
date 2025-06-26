import 'package:flutter/material.dart';

//this file contains all theme (not so important)

//light mode
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade600,
    inversePrimary: Colors.black,
  ),
);

//dark mode
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade800,
    inversePrimary: Colors.white,
  ),
);
