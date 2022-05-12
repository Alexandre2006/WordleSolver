import 'package:flutter/material.dart';
import 'package:wordle_solver/global/sharedpreferences.dart';
import 'package:wordle_solver/global/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "Preferences",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Theme:  ",
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton(
                  value: mytheme.theme,
                  onChanged: (int? newValue) {
                    setState(() {
                      if (newValue != null) {
                        mytheme.setTheme(newValue);
                      }
                    });
                  },
                  items: const <DropdownMenuItem<int>>[
                    DropdownMenuItem(value: 0, child: Text("System Default")),
                    DropdownMenuItem(value: 1, child: Text("Light")),
                    DropdownMenuItem(value: 2, child: Text("Dark")),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Word Length: ${sharedPreferences.getInt("dev.thinkalex.solver.wordle_length") ?? 5}",
                  style: const TextStyle(fontSize: 16),
                ),
                Slider(
                  min: 4,
                  max: 11,
                  divisions: 8,
                  value: (sharedPreferences
                              .getInt("dev.thinkalex.solver.wordle_length") ??
                          5)
                      .toDouble(),
                  onChanged: (double newValue) => setState(
                    () {
                      sharedPreferences.setInt(
                        "dev.thinkalex.solver.wordle_length",
                        newValue.toInt(),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
