import 'package:flutter/material.dart';
import 'package:wordle_solver/services/letter_utils.dart';
import 'package:wordle_solver/shared/wordle_box.dart';

class WordleRow extends StatefulWidget {
  WordleRow({
    Key? key,
    required this.length,
    this.enabled = false,
    required this.colors,
    this.text = "               ",
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
  List<FocusNode> focusNodes = [];

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

    // Configure Focus Nodes
    for (int i = 0; i < widget.length; i++) {
      focusNodes.add(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.enabled ? 104 : 54,
      width: MediaQuery.of(context).size.width - 20,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.length,
          itemBuilder: (BuildContext context, int number) {
            return WordleBox(
              enabled: widget.enabled,
              color: widget.colors[number],
              controller: controllers[number],
              focusNode: focusNodes[number],
              onEmptied: number > 0
                  ? () {
                      // Focus Node
                      focusNodes[number - 1].requestFocus();
                      // Update text
                      widget.text = replaceCharAt(widget.text, number, " ");
                    }
                  : () {
                      // Update text
                      if (widget.text.length != widget.length) {
                        widget.text = String.fromCharCodes(
                          Iterable.generate(
                            widget.length,
                            (_) => ' '.codeUnits.first,
                          ),
                        );
                      }
                      widget.text = replaceCharAt(widget.text, number, " ");
                    },
              onFilled: number < widget.length - 1
                  ? () {
                      // Focus Node
                      focusNodes[number + 1].requestFocus();
                      // Update text
                      if (widget.text.length != widget.length) {
                        widget.text = String.fromCharCodes(
                          Iterable.generate(
                            widget.length,
                            (_) => ' '.codeUnits.first,
                          ),
                        );
                      }
                      widget.text = replaceCharAt(
                        widget.text,
                        number,
                        controllers[number].text.characters.last,
                      );
                    }
                  : () {
                      // Update text
                      if (widget.text.length != widget.length) {
                        widget.text = String.fromCharCodes(
                          Iterable.generate(
                            widget.length,
                            (_) => ' '.codeUnits.first,
                          ),
                        );
                      }
                      widget.text = replaceCharAt(
                        widget.text,
                        number,
                        controllers[number].text.characters.last,
                      );
                    },
              onColorChange: (int newColor) {
                // Update Color
                widget.colors[number] = newColor;
              },
            );
          },
        ),
      ),
    );
  }
}
