import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

Future<void> sharedPreferencesInit() async {
  sharedPreferences = await SharedPreferences.getInstance();
}

Future<bool> getFirstRun() async {
  final bool firstRun =
      sharedPreferences.getBool("dev.thinkalex.solver.firstrun") ?? true;
  if (firstRun) {
    await sharedPreferences.setBool("dev.thinkalex.solver.firstrun", false);
  }
  return firstRun;
}
