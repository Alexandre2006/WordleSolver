import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wordle_solver/global/solver.dart';
import 'package:wordle_solver/services/solver.dart';
import 'package:wordle_solver/shared/wordle_row.dart';

class WordleBoard extends StatefulWidget {
  const WordleBoard({Key? key}) : super(key: key);

  @override
  State<WordleBoard> createState() => _WordleBoardState();
}

class _WordleBoardState extends State<WordleBoard> {
  @override
  void initState() {
    super.initState();
    solver = Solver();
    solver.addListener(
      () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 410,
      alignment: Alignment.center,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: solver.status.item2 != SolveStatus.unsolved ? 7 : 6,
        itemBuilder: (BuildContext context, int index) {
          // In the case that the row has been filled already
          if (index < solver.previousGuesses.length) {
            return Center(
              child: WordleRow(
                length: solver.length,
                enabled: false,
                text: solver.previousGuesses[index].toUpperCase(),
                colors: solver.previousColors[index],
              ),
            );
          }
          // In the case that the row is the one to be guessed
          else if (index == solver.previousColors.length) {
            return Center(
              child: WordleRow(
                length: solver.length,
                text: solver.status.item1 == ""
                    ? null
                    : solver.status.item1.toUpperCase(),
                enabled: solver.status.item2 == SolveStatus.unsolved,
                colors: solver.status.item2 == SolveStatus.unsolved
                    ? List.filled(solver.length, 0)
                    : solver.status.item2 == SolveStatus.solved
                        ? List.filled(solver.length, 2)
                        : List.filled(solver.length, -1),
              ),
            );
          }
          // In the case that the row is not activate
          else if (index < 6) {
            return Center(
              child: WordleRow(length: solver.length, enabled: false),
            );
          }
          // In the case that a reset button should be visible
          else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: TextButton.icon(
                    onPressed: () {
                      Phoenix.rebirth(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(
                                        255,
                                        58,
                                        57,
                                        61,
                                      )
                                    : const Color.fromARGB(
                                        255,
                                        212,
                                        214,
                                        218,
                                      ),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
