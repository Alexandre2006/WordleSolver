import 'package:flutter/material.dart';
import 'package:wordle_solver/shared/wordle_box.dart';

class WordleRow extends StatefulWidget {
  WordleRow({
    Key? key,
    required this.length,
    this.enabled = false,
    required this.colors,
    this.text = "",
  }) : super(key: key);

  int length;
  bool enabled;
  List<int> colors;
  String text;

  @override
  State<WordleRow> createState() => _WordleRowState();
}

class _WordleRowState extends State<WordleRow> {
  List<TextEditingController> controllers = [];

  String getText() {
    String text = "";
    for (final TextEditingController controller in controllers) {
      if (controller.text != "\u200b" && controller.text != " ") {
        text += controller.text.characters.last;
      } else {
        text += " ";
      }
    }
    print(text);
    return text;
  }

  @override
  void initState() {
    super.initState();
    // Configure Text
    if (widget.text == "") {
      widget.text = String.fromCharCodes(
        Iterable.generate(widget.length, (_) => ' '.codeUnits.first),
      );
    }
    // Configure Colors
    if (widget.colors.isEmpty) {
      widget.colors = List.filled(widget.length, widget.enabled ? 0 : -1);
    }

    // Configure Controllers
    for (int i = 0; i < widget.length; i++) {
      controllers.add(TextEditingController());
      if (widget.text[i] == " ") {
        controllers[i].text = "\u200b";
      } else {
        controllers[i].text = "\u200b${widget.text[i]}";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.enabled ? 104 : 54,
      width: MediaQuery.of(context).size.width - 20,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.length,
        itemBuilder: (BuildContext context, int number) {
          return WordleBox(
            controller: controllers[number],
            onEmptied: () {
              widget.text = getText();
              if (number != 0) {
                FocusScope.of(context).previousFocus();
              }
            },
            onFilled: () {
              widget.text = getText();
              FocusScope.of(context).nextFocus();
            },
            onColorChange: (int newVal) {
              widget.colors[number] = newVal;
            },
            color: widget.colors[number],
            enabled: widget.enabled,
          );
        },
      ),
    );
  }
}
