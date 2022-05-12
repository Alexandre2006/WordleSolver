import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wordle_solver/pages/docs/docs.dart';
import 'package:wordle_solver/pages/settings/settings.dart';
import 'package:wordle_solver/shared/wordle_board.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: FittedBox(
            child: Text("Wordle Solver"),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DocsScreen(),
              ),
            );
          },
          icon: const Icon(Icons.help),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Phoenix.rebirth(context);
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: const Center(
        child: WordleBoard(),
      ),
    );
  }
}
