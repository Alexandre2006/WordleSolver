import 'package:wordle_solver/data/allwords.dart';
import 'package:wordle_solver/data/words5.dart';

List<String> words3 = [];
List<String> words4 = [];
List<String> words6 = [];
List<String> words7 = [];
List<String> words8 = [];
List<String> words9 = [];
List<String> words10 = [];
List<String> words11 = [];

Map<int, List<String>> words = {
  3: words3,
  4: words4,
  5: words5,
  6: words6,
  7: words7,
  8: words8,
  9: words9,
  10: words10,
  11: words11,
};

void initWords() {
  for (final String word in allWords) {
    switch (word.length) {
      case 3:
        words3.add(word);
        break;
      case 4:
        words4.add(word);
        break;
      case 6:
        words6.add(word);
        break;
      case 7:
        words7.add(word);
        break;
      case 8:
        words8.add(word);
        break;
      case 9:
        words9.add(word);
        break;
      case 10:
        words10.add(word);
        break;
      case 11:
        words11.add(word);
        break;
    }
  }
}
