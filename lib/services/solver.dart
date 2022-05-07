import 'package:tuple/tuple.dart';
import 'package:wordle_solver/data/words.dart';
import 'package:wordle_solver/services/letterutils.dart';

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

  // Instantiation - Create Object
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

  // Checks word using gathered data
  bool _checkWord(String word) {
    // Keep track of validity
    bool valid = true;

    // Get letters in word
    Map<String, int> wordLetters = countLetters(word);

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
    for (var letter in _confirmedPositions) {
      if (letter != "" && word[i] != letter) {
        valid = false;
      }
      i++;
    }

    if (!valid) return false;

    // Step 4: Check invalid positions
    i = 0;
    for (var letterList in _antiConfirmedPositions) {
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
    Map<String, int> guessLetterCount = countLetters(word);
    Map<String, int> guessLetterCountConfirmed =
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
    for (var color in colors) {
      if (color == 2) {
        _confirmedPositions[i] = word[i];
      } else if (color == 1) {
        _antiConfirmedPositions[i].add(word[i]);
      }
      i++;
    }
  }

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

  Tuple2<String, solveStatus> guess(String guess, List<int> guessColors) {
    // Update frontend data
    previousColors.add(guessColors);
    previousGuesses.add(guess);

    // Update backend data
    _update(guess, guessColors);

    // Remove all invalid solutions
    _removeAllInvalidGuesses();

    // Return optimal solution
    if (_solutions.isEmpty) {
      return const Tuple2("XXXXX", solveStatus.failed);
    } else if (_solutions.length == 1) {
      return Tuple2(_solutions.first, solveStatus.solved);
    } else {
      return Tuple2(_solutions.first, solveStatus.unsolved);
    }
  }
}
