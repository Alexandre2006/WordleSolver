import 'package:flutter/material.dart';
import 'package:wordle_solver/fonts/fonts.dart';
import 'package:wordle_solver/global/solver.dart';
import 'package:wordle_solver/themes/wordle_colors.dart';

class WordleRow extends StatefulWidget {
  const WordleRow({
    Key? key,
    this.colors,
    this.enabled = true,
    this.text,
    required this.length,
  }) : super(key: key);
  final List<int>? colors;
  final bool enabled;
  final String? text;
  final int length;

  @override
  State<WordleRow> createState() => _WordleRowState();
}

class _WordleRowState extends State<WordleRow> {
  List<int> colors = [];
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    // Clear everything
    colors = [];
    controllers = [];
    focusNodes = [];

    // Add Colors
    if (widget.colors == null || widget.colors!.length != widget.length) {
      colors = widget.enabled
          ? List.filled(widget.length, 0)
          : List.filled(widget.length, -1);
    } else {
      colors = List.from(widget.colors!);
    }

    // Add controllers & Focus Nodes
    for (int i = 0; i < 11; i++) {
      if (widget.text != null && widget.text!.length > i) {
        controllers
            .add(TextEditingController(text: "\u200b${widget.text![i]}"));
      } else {
        controllers.add(TextEditingController(text: "\u200b"));
      }
      focusNodes.add(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.enabled ? 150 : 54,
      width: widget.length * 54,
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: widget.enabled ? 102 : 54,
            width: widget.length * 54,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.enabled ? widget.length : widget.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    key: ValueKey<int>(colors[index]),
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: colors[index] != -1
                                ? Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? darkWordleColors[colors[index]]
                                    : lightWordleColors[colors[index]]
                                : Colors.transparent,
                            border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(
                                      255,
                                      58,
                                      57,
                                      61,
                                    )
                                  : const Color.fromARGB(
                                      255,
                                      212,
                                      214,
                                      218,
                                    ),
                            ),
                          ),
                          child: TextField(
                            enableInteractiveSelection: false,
                            enableIMEPersonalizedLearning: false,
                            enableSuggestions: false,
                            autocorrect: false,
                            textAlign: TextAlign.center,
                            enabled: widget.enabled,
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              fontFamily: clearSans,
                              color: Theme.of(context).brightness ==
                                          Brightness.light &&
                                      widget.colors![index] == -1
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 30,
                            ),
                            onChanged: (String newValue) {
                              final int length = newValue.length;
                              // If 0 characters are present, the backspace key was hit when the box was empty, so remove the contents of the previous box
                              if (length == 0) {
                                controllers[index].text = "\u200b";
                                if (index > 0) {
                                  controllers[index - 1].text = "\u200b";
                                  if (index > 1) {
                                    focusNodes[index - 2].requestFocus();
                                  } else {
                                    focusNodes[index - 1].requestFocus();
                                  }
                                }
                              }
                              // If length = 1, a character was delete, so only go back 1 space
                              else if (length == 1) {
                                controllers[index].text = "\u200b";
                                if (index > 0) {
                                  focusNodes[index - 1].requestFocus();
                                }
                              }
                              // If length = 2, a new character was added when the box was empty (only allow input of valid characters)
                              else if (length == 2) {
                                if (!RegExp(r'^[a-zA-Z]+$')
                                    .hasMatch(newValue[1])) {
                                  controllers[index].text = "\u200b";
                                } else if (index < (widget.length - 1)) {
                                  focusNodes[index + 1].requestFocus();
                                }
                                controllers[index].text =
                                    controllers[index].text.toUpperCase();
                              }
                              // If length = 3, a new character was inputted and should be put into the next box
                              else if (RegExp(r'^[a-zA-Z]+$')
                                  .hasMatch(newValue.substring(1, 3))) {
                                if (index < (widget.length - 1)) {
                                  controllers[index + 1].text =
                                      "\u200b${newValue[2].toUpperCase()}";
                                  if (index < (widget.length - 2)) {
                                    focusNodes[index + 2].requestFocus();
                                  } else {
                                    focusNodes[index + 1].requestFocus();
                                  }
                                }
                                controllers[index].text =
                                    "\u200b${newValue[1].toUpperCase()}";
                              }
                              controllers[index].selection =
                                  TextSelection.collapsed(
                                offset: controllers[index].text.length,
                              );
                            },
                            onTap: () {
                              controllers[index].selection =
                                  TextSelection.collapsed(
                                offset: controllers[index].text.length,
                              );
                            },
                          ),
                        ),
                        if (widget.enabled)
                          IconButton(
                            splashRadius: 16,
                            onPressed: () {
                              setState(() {
                                colors[index]++;
                                if (colors[index] > 2) {
                                  colors[index] = 0;
                                }
                              });
                            },
                            icon: const Icon(Icons.color_lens),
                          )
                        else
                          const SizedBox.shrink()
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.enabled)
            Center(
              child: Padding(
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 125,
                  height: 35,
                  child: TextButton(
                    onPressed: () {
                      String currentText = "";
                      for (int i = 0; i < widget.length; i++) {
                        if (controllers[i].text.length < 2) {
                          currentText += " ";
                        } else {
                          currentText += controllers[i].text[1];
                        }
                      }
                      // Check if valid
                      if (solver.validateGuess(currentText.toLowerCase())) {
                        solver.guess(
                          currentText.toLowerCase(),
                          colors.sublist(0, widget.length),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Invalid Guess!"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Close"),
                                )
                              ],
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text(
                                      'The word you tried to guess is invalid!\n',
                                    ),
                                    Text(
                                      'Note: Not all words are valid guesses',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(
                                        255,
                                        58,
                                        57,
                                        61,
                                      )
                                    : const Color.fromARGB(
                                        255,
                                        212,
                                        214,
                                        218,
                                      ),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ),
              ),
            )
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}
