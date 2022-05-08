import 'package:flutter/material.dart';
import 'package:wordle_solver/fonts/fonts.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 18, 18, 19),
      shape: Border(
        bottom: BorderSide(color: Color.fromARGB(255, 58, 57, 61), width: 1),
      ),
      titleTextStyle: TextStyle(fontFamily: karnakCondensed, fontSize: 37),
      elevation: 0),
  useMaterial3: true,
  backgroundColor: const Color.fromARGB(255, 18, 18, 19),
  canvasColor: const Color.fromARGB(255, 18, 18, 19),
  scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 19),
);
