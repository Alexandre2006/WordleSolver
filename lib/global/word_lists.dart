import 'dart:convert';

import 'package:flutter/services.dart';

Map<int, List<String>> wordLists = {};

Future<void> initWords() async {
  for (int i = 2; i < 16; i++) {
    final List<dynamic> dynamicWords =
        jsonDecode(await rootBundle.loadString("lib/data/${i}letterWords.json"))
            as List<dynamic>;
    wordLists[i] = dynamicWords.cast<String>();
  }
}
