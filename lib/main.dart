import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wordle_solver/global/sharedpreferences.dart';
import 'package:wordle_solver/global/theme.dart';
import 'package:wordle_solver/global/word_lists.dart';
import 'package:wordle_solver/pages/home/home.dart';
import 'package:wordle_solver/themes/dark.dart';
import 'package:wordle_solver/themes/light.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Globals
  sharedPreferencesInit().then(
    (value) => {
      initWords().then(
        (value) => {runApp(Phoenix(child: MyApp()))},
      )
    },
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyTheme myTheme = MyTheme();

  @override
  void initState() {
    super.initState();
    mytheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle Solver',
      home: const HomeScreen(),
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: mytheme.currentTheme(context),
    );
  }
}
