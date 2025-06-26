import 'package:flutter/material.dart';
import 'package:music_app/themes/themes.dart';

//this file let u switch between light and dark mode
class ThemeProvider extends ChangeNotifier {
  //default is light mode
  ThemeData _themeData = lightMode;
  //get theme from above
  ThemeData get themeData => _themeData;
  //check if dark mode is on or off
  bool get isDarkMode => _themeData == darkMode;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); //update UI
  }

  void toogleTheme() {
    if (_themeData == lightMode) {
      themeData == darkMode;
    } else {
      (themeData == lightMode);
    }
  }
}
