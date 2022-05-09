// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/material.dart';
import 'package:wordle_solver/global/sharedpreferences.dart';

MyTheme mytheme = MyTheme();

class MyTheme with ChangeNotifier {
  int theme = 0;

  MyTheme() {
    theme = sharedPreferences.getInt("dev.thinkalex.solver.theme") ?? 0;
  }

  ThemeMode currentTheme(BuildContext context) {
    return theme == 0
        ? ThemeMode.system
        : theme == 1
            ? ThemeMode.light
            : ThemeMode.dark;
  }

  void setTheme(int newTheme) {
    theme = newTheme;
    sharedPreferences.setInt("dev.thinkalex.solver.theme", theme);
    notifyListeners();
  }
}
