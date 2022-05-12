import 'package:flutter/material.dart';
import 'package:wordle_solver/fonts/fonts.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    iconTheme: IconThemeData(color: Colors.black),
    shape: Border(
      bottom: BorderSide(color: Color.fromARGB(255, 212, 214, 218)),
    ),
    titleTextStyle: TextStyle(
      fontFamily: karnakCondensed,
      fontSize: 37,
      color: Colors.black,
    ),
    elevation: 1,
  ),
  useMaterial3: true,
  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  canvasColor: const Color.fromARGB(255, 255, 255, 255),
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  dividerColor: const Color.fromARGB(255, 212, 214, 218),
  iconTheme: const IconThemeData(color: Colors.black),
  primaryIconTheme: const IconThemeData(color: Colors.black),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        const Color.fromARGB(255, 255, 255, 255),
      ),
    ),
  ),
);
