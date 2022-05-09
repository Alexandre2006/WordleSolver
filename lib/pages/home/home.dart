import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:tuple/tuple.dart';
import 'package:wordle_solver/pages/settings/settings.dart';
import 'package:wordle_solver/services/solver.dart';
import 'package:wordle_solver/shared/wordle_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Solver solver = Solver();
  Tuple2<String, solveStatus> status = const Tuple2("", solveStatus.unsolved);
  late WordleRow currentGuessWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Wordle Solver"),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (BuildContext context, int number) {
              // Previously guessed
              if (number < solver.previousColors.length) {
                return WordleRow(
                  length: solver.length,
                  colors: solver.previousColors[number],
                  text: solver.previousGuesses[number].toUpperCase(),
                );
              }
              // Currently Guessing
              else if (number == solver.previousColors.length) {
                currentGuessWidget = WordleRow(
                  length: solver.length,
                  enabled: status.item2 == solveStatus.unsolved,
                  text: status.item1.toUpperCase(),
                  colors: status.item2 == solveStatus.solved
                      ? List.filled(solver.length, 2)
                      : List.filled(solver.length, 0),
                );
                return Column(
                  children: [
                    Center(child: currentGuessWidget),
                    if (status.item2 == solveStatus.unsolved)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Validate Guess
                            if (!solver.validateGuess(
                              currentGuessWidget.text.toLowerCase(),
                            )) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Invalid Guess'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text(
                                            'NOTE: Not all English words are valid Wordle answers!',
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Okay!'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              setState(() {
                                status = solver.guess(
                                  currentGuessWidget.text.toLowerCase(),
                                  currentGuessWidget.colors,
                                );
                              });
                            }
                          },
                          icon: const Text("Submit"),
                          label: const Icon(Icons.arrow_right_alt),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Phoenix.rebirth(context);
                          },
                          label: const Text("Restart"),
                          icon: const Icon(
                            Icons.refresh,
                          ),
                        ),
                      )
                  ],
                );
              } else {
                return Center(
                  child: WordleRow(
                    length: solver.length,
                    colors: List.filled(solver.length, -1),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
