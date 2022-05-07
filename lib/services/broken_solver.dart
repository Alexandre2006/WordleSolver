import 'package:tuple/tuple.dart';
import 'package:wordle_solver/data/words.dart';
  // Utility Function - Adds Data
  void _update(String guess, List<int> colors) {
    guessLetterCount.forEach((key, value) {
      if ((guessLetterCount[key] ??= 0) >
          (guessLetterCountConfirmed[key] ??= 0)) {
        _guaranteedLetterCount[key] = guessLetterCountConfirmed[key] ??= 0;
        _minimumLetterCount[key] = guessLetterCountConfirmed[key] ??= 0;
      } else if (value > (_minimumLetterCount[key] ??= 0)) {
        _minimumLetterCount[key] = value;
      }
    });

    // Find Obvious Confirmed and Anti Confirmed Positions
    int i = 0;
    for (var resultVal in colors) {
      if (resultVal == 2) {
        _confirmedPositions[i] = guess[i];
      } else {
        _antiConfirmedPositions[i].add(guess[i]);
      }
      i++;
    }
  }

  // Endpoint for guesser
  Tuple2<String, solveStatus> guess(String word, List<int> colors) {
    // Register Guess
    previousColors.add(colors);
    previousGuesses.add(word);

    // Remove invalid guesses
    _update(word, colors);
    _removeAllInvalidGuesses();

    // Return Guess
    if (_solutions.isEmpty) {
      return Tuple2(
        String.fromCharCodes(
          Iterable.generate(
            length,
            (_) => "X".codeUnitAt(0),
          ),
        ),
        solveStatus.failed,
      );
    } else {
      return Tuple2(
        _solutions[0],
        _solutions.length == 1 ? solveStatus.solved : solveStatus.unsolved,
      );
    }
  }
}
