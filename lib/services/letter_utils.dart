// Counts each character in word, with optional validator restricting counting to certain colors
Map<String, int> countLetters(
  String word, {
  List<int>? colors,
  List<int>? validator,
}) {
  final Map<String, int> letterCount = {};
  int i = 0;
  for (final character in word.runes) {
    // Check validator if necessary
    if ((validator == null || colors == null) ||
        validator.contains(colors[i])) {
      if (letterCount.containsKey(String.fromCharCode(character))) {
        letterCount[String.fromCharCode(character)] =
            letterCount[String.fromCharCode(character)]! + 1;
      } else {
        letterCount[String.fromCharCode(character)] = 1;
      }
    }
    i++;
  }
  return letterCount;
}
