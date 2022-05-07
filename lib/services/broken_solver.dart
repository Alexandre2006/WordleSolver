import 'package:tuple/tuple.dart';
import 'package:wordle_solver/data/words.dart';

// Status Enum
enum solveStatus { unsolved, solved, failed }

class Solver {
  // Shared Variables (Public)
  List<List<int>> previousColors = [];
  List<String> previousGuesses = [];

  // Configuration Variables (Final)
  final int length;

  // Internal Variables (Private)
  late List<List<String>> _antiConfirmedPositions;
  Map<String, int> _guaranteedLetterCount = {};
  Map<String, int> _minimumLetterCount = {};
  late List<String> _confirmedPositions;
  List<String> _solutions = [];

  // Instantiation - Organize Original Creation
  Solver(this.length) {
    // Initialize Variables
    _confirmedPositions = List.filled(length, "");
    _antiConfirmedPositions = List.filled(length, []);

    for (int i = 0; i < length; i++) {
      _antiConfirmedPositions[i] = [];
    }

    // Load Words
    _solutions = words[length]!;
  }

  // Utility Function - Counts letters with specific colors in word
  Map<String, int> _countLetters(
      String word, List<int> colors, List<int> validator) {
    // Create letter count
    Map<String, int> letterCount = {};

    // Loop over every character
    int i = 0;
    for (var character in word.runes) {
      // Get Character
      String char = String.fromCharCode(character);
      // Count character if validator met
      if (validator.contains(colors[i])) {
        // Set to 1 if no value is present
        if (!letterCount.containsKey(char)) {
          letterCount[char] = 1;
        } else {
          // Otherwise increase
          letterCount[char] = letterCount[char]! + 1;
        }
      }
      i++;
    }
    // Return letter count
    return letterCount;
  }

  // Utility Function - Verifies word
  bool _checkWord(String word) {
    bool valid = true;
    // Remove all guesses that do not pass minimum letter counts
    Map<String, int> wordLetterCount =
        _countLetters(word, List.filled(word.length, 0), [0]);
    _minimumLetterCount.forEach((key, value) {
      if ((wordLetterCount[key] ??= 0) < value) {
        valid = false;
      }
    });
    if (!valid) {
      if (word == "arise") {
        print(1.toString());
      }
      return false;
    }
    // Remove all guesses that do not pass exact letter counts
    _guaranteedLetterCount.forEach((key, value) {
      if ((wordLetterCount[key] ??= 0) != value) {
        valid = false;
      }
    });
    if (!valid) {
      if (word == "arise") {
        print(2.toString());
      }
      return false;
    }
    // Remove all guesses that do not have exact positions matching
    for (int i = 0; i < length; i++) {
      if (_confirmedPositions[i] != "" && _confirmedPositions[i] != word[i]) {
        if (word == "arise") {
          print(3.toString());
        }
        return false;
      }
    }
    // Remove words that have wrong letters in positions
    for (int i = 0; i < length; i++) {
      if (_antiConfirmedPositions[i].contains(word[i])) {
        if (word == "arise") {
          print(4.toString());
        }
        return false;
      }
    }
    if (!valid) {
      return false;
    } else {
      return true;
    }
  }

  // EOU Function - Checks all words using gathered data
  void _removeAllInvalidGuesses() {
    List<String> toRemove = [];
    for (var solution in _solutions) {
      if (!_checkWord(solution)) {
        toRemove.add(solution);
      }
    }
    for (var removal in toRemove) {
      _solutions.remove(removal);
    }
  }

  // Utility Function - Adds Data
  void _update(String guess, List<int> colors) {
    // Find minimum + confirmed letter counts
    Map<String, int> guessLetterCount = _countLetters(guess, colors, [0, 1, 2]);
    Map<String, int> guessLetterCountConfirmed =
        _countLetters(guess, colors, [1, 2]);
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
