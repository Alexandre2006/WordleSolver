import 'package:flutter/material.dart';
import 'package:wordle_solver/fonts/fonts.dart';
import 'package:wordle_solver/themes/wordle_colors.dart';

class WordleBox extends StatefulWidget {
  WordleBox({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onEmptied,
    required this.onFilled,
    required this.onColorChange,
    this.enabled = true,
    this.color = 0,
  }) : super(key: key);

  TextEditingController controller;
  FocusNode focusNode;
  Function() onEmptied;
  Function() onFilled;
  Function(int) onColorChange;
  bool enabled;
  int color;

  @override
  State<WordleBox> createState() => _WordleBoxState();
}

class _WordleBoxState extends State<WordleBox> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.text == "") {
      widget.controller.text = "\u200b";
    } else {
      widget.controller.text =
          "\u200b${widget.controller.text.characters.last}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 50,
        height: 90,
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                alignment: Alignment.center,
                key: ValueKey<int>(widget.color),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.color == -1
                      ? Colors.transparent
                      : Theme.of(context).brightness == Brightness.dark
                          ? darkWordleColors[widget.color]
                          : lightWordleColors[widget.color],
                  border: Border.all(
                    color: widget.color == -1
                        ? Theme.of(context).dividerColor
                        : Theme.of(context).brightness == Brightness.dark
                            ? darkWordleColors[widget.color]
                            : lightWordleColors[widget.color],
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  style: const TextStyle(
                    fontFamily: clearSans,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  enabled: widget.enabled,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 4),
                    errorBorder: InputBorder.none,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  onTap: () {
                    widget.controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: widget.controller.text.length),
                    );
                  },
                  textAlign: TextAlign.center,
                  onChanged: (String newValue) {
                    if (newValue == "\u200b" || newValue == "") {
                      widget.onEmptied();
                      widget.controller.text = "\u200b";
                      widget.controller.selection = TextSelection.fromPosition(
                        const TextPosition(offset: 1),
                      );
                    } else if (RegExp("[a-zA-Z]")
                        .hasMatch(newValue.characters.last)) {
                      widget.onFilled();
                      widget.controller.text =
                          "\u200b${newValue.characters.last.toUpperCase()}";
                      widget.controller.selection = TextSelection.fromPosition(
                        const TextPosition(offset: 2),
                      );
                    } else {
                      widget.controller.text =
                          "\u200b${newValue.substring(newValue.length - 2, newValue.length - 1)}";
                      widget.controller.selection = TextSelection.fromPosition(
                        const TextPosition(offset: 2),
                      );
                    }
                  },
                ),
              ),
            ),
            if (widget.enabled)
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.color++;
                    if (widget.color > 2) {
                      widget.color = 0;
                    }
                    widget.onColorChange(widget.color);
                  });
                },
                icon: const Icon(Icons.color_lens),
                splashRadius: 16,
              )
            else
              const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

// Way to access Text    - TextEditinController
// Way to access focus   - FocusNode
// Way to switch focus   - OnFilled - OnEmptied
// Way to access color   - Color
// Way to mark active / not - enabled
