import 'package:flutter/material.dart';
import 'package:wordle_solver/fonts/fonts.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 18, 18, 19),
    shape: Border(
      bottom: BorderSide(color: Color.fromARGB(255, 58, 57, 61)),
    ),
    titleTextStyle: TextStyle(fontFamily: butler, fontSize: 37),
    elevation: 1,
  ),
  useMaterial3: true,
  backgroundColor: const Color.fromARGB(255, 18, 18, 19),
  canvasColor: const Color.fromARGB(255, 18, 18, 19),
  scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 19),
  dividerColor: const Color.fromARGB(255, 58, 57, 61),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        const Color.fromARGB(255, 18, 18, 19),
      ),
    ),
  ),
);
