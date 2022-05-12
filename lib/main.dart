import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wordle_solver/global/sharedpreferences.dart';
import 'package:wordle_solver/global/theme.dart';
import 'package:wordle_solver/global/word_lists.dart';
import 'package:wordle_solver/pages/docs/docs.dart';
import 'package:wordle_solver/pages/home/home.dart';
import 'package:wordle_solver/themes/dark.dart';
import 'package:wordle_solver/themes/light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Globals
  await sharedPreferencesInit();
  await initWords();
  runApp(Phoenix(child: const MyApp()));
  await getFirstRun();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyTheme myTheme = MyTheme();
  late bool firstRun;

  @override
  void initState() {
    super.initState();
    firstRun =
        sharedPreferences.getBool("dev.thinkalex.solver.firstrun") ?? true;

    mytheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle Solver',
      home: firstRun ? const DocsScreen() : const HomeScreen(),
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: mytheme.currentTheme(context),
    );
  }
}
