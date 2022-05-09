import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wordle_solver/data/words.dart';
import 'package:wordle_solver/global/sharedpreferences.dart';
import 'package:wordle_solver/global/theme.dart';
import 'package:wordle_solver/pages/home/home.dart';
import 'package:wordle_solver/themes/dark.dart';
import 'package:wordle_solver/themes/light.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initWords();
  sharedPreferencesInit()
      .then((value) => runApp(Phoenix(child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      theme: lightTheme,
      themeMode: mytheme.currentTheme(context),
      darkTheme: darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
