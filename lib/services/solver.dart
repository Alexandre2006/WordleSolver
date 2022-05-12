import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:wordle_solver/global/sharedpreferences.dart';
import 'package:wordle_solver/global/word_lists.dart';
import 'package:wordle_solver/services/letter_utils.dart';

enum SolveStatus { unsolved, solved, failed }

class Solver with ChangeNotifier {
  // Shared Variables (Public)
  List<List<int>> previousColors = [];
  List<String> previousGuesses = [];
  Tuple2<String, SolveStatus> status = const Tuple2("", SolveStatus.unsolved);

  // Configuration Variables (Final)
  late int length;

  // Internal Variables (Private)
  late List<List<String>> _antiConfirmedPositions;
  Map<String, int> _guaranteedLetterCount = {};
  Map<String, int> _minimumLetterCount = {};
  late List<String> _confirmedPositions;
  List<String> _solutions = [];

  // Instantiation - Create Object
  Solver() {
    reset();
  }

  // Checks word using gathered data
  bool _checkWord(String word) {
    // Keep track of validity
    bool valid = true;

    // Get letters in word
    final Map<String, int> wordLetters = countLetters(word);

    // Step 1: Minimum Letter Count
    _minimumLetterCount.forEach((letter, letterCount) {
      if ((wordLetters[letter] ??= 0) < letterCount) {
        valid = false;
      }
    });

    if (!valid) return false;

    // Step 2: Exact Letter Count
    _guaranteedLetterCount.forEach((letter, letterCount) {
      if ((wordLetters[letter] ??= 0) != letterCount) {
        valid = false;
      }
    });

    if (!valid) return false;

    // Step 3: Check exact positions
    int i = 0;
    for (final letter in _confirmedPositions) {
      if (letter != "" && word[i] != letter) {
        valid = false;
      }
      i++;
    }

    if (!valid) return false;

    // Step 4: Check invalid positions
    i = 0;
    for (final letterList in _antiConfirmedPositions) {
      if (letterList.contains(word[i])) {
        valid = false;
      }
      i++;
    }

    if (!valid) return false;
    return true;
  }

  void _update(String word, List<int> colors) {
    // Fetch Data
    final Map<String, int> guessLetterCount = countLetters(word);
    final Map<String, int> guessLetterCountConfirmed =
        countLetters(word, colors: colors, validator: [1, 2]);

    // Gather Letter Count Data
    guessLetterCount.forEach((letter, letterCount) {
      // In cases where the amount of letters counted is more than confirmed | Must be exactly X amount
      if (letterCount > (guessLetterCountConfirmed[letter] ??= 0)) {
        _minimumLetterCount[letter] = guessLetterCountConfirmed[letter] ??= 0;
        _guaranteedLetterCount[letter] =
            guessLetterCountConfirmed[letter] ??= 0;
      } else {
        // In cases where the amounts of letter counted is equal to confirmed | Must be at least X amount
        _minimumLetterCount[letter] = guessLetterCountConfirmed[letter] ??= 0;
      }
    });

    // Gather confirmed positions
    int i = 0;
    for (final color in colors) {
      if (color == 2) {
        _confirmedPositions[i] = word[i];
      } else if (color == 1) {
        _antiConfirmedPositions[i].add(word[i]);
      }
      i++;
    }
  }

  void _removeAllInvalidGuesses() {
    final List<String> toRemove = [];
    for (final solution in _solutions) {
      if (!_checkWord(solution)) {
        toRemove.add(solution);
      }
    }
    for (final removal in toRemove) {
      _solutions.remove(removal);
    }
  }

  void guess(String guess, List<int> guessColors) {
    // Update frontend data
    previousColors.add(guessColors);
    previousGuesses.add(guess);

    // Update backend data
    _update(guess, guessColors);

    // Remove all invalid solutions
    _removeAllInvalidGuesses();

    // Return optimal solution
    if (_solutions.isEmpty) {
      // Retry before returning
      _solutions = List.from(wordLists[length]!);
      _removeAllInvalidGuesses();
    }

    if (_solutions.isEmpty) {
      status = const Tuple2("XXXXX", SolveStatus.failed);
    } else if (_solutions.length == 1) {
      status = Tuple2(_solutions.first, SolveStatus.solved);
    } else {
      status = Tuple2(_solutions.first, SolveStatus.unsolved);
    }
    notifyListeners();
  }

  void reset() {
    // Setup Length
    length =
        sharedPreferences.getInt("dev.thinkalex.solver.wordle_length") ?? 5;

    // Initialize Variables
    _confirmedPositions = List.filled(length, "");
    _antiConfirmedPositions = List.filled(length, []);
    _guaranteedLetterCount = {};
    _minimumLetterCount = {};

    for (int i = 0; i < length; i++) {
      _antiConfirmedPositions[i] = [];
    }

    // Load Words
    _solutions = List.from(wordLists[length]!);

    // Remove Previous Guess
    previousColors = [];
    previousGuesses = [];

    // Update Status
    status = const Tuple2("", SolveStatus.unsolved);

    // Notify Listeners
    notifyListeners();
  }

  // Guess Validator
  bool validateGuess(String guess) {
    if (guess.length == 5) {
      return wordLists[55]!.contains(guess);
    } else {
      return wordLists[length]!.contains(guess);
    }
  }
}
