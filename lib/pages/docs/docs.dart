import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wordle_solver/pages/home/home.dart';
import 'package:wordle_solver/shared/wordle_row.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      done: const Text('Done'),
      onDone: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
      next: const Text('Next'),
      skip: const Text('Skip'),
      showSkipButton: true,
      isProgress: false,
      onSkip: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Welcome to Wordle Solver",
          decoration: const PageDecoration(bodyAlignment: Alignment.center),
          bodyWidget: const Text(
            "This short guide will show you how to solve any Wordle puzzle using this app!",
            textAlign: TextAlign.center,
          ),
        ),
        PageViewModel(
          title: "Guess Input",
          image: const WordleRow(
            text: "WORDS",
            colors: [0, 1, 2, 1, 0],
            length: 5,
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "To submit a guess, enter the guessed word into the text box, adjust its colors using the buttons below each box, and hit the submit button!",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        PageViewModel(
          title: "Guess Input",
          image: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                WordleRow(
                  text: "WORDS",
                  colors: [0, 1, 2, 1, 0],
                  length: 5,
                  enabled: false,
                ),
                WordleRow(
                  text: "PARTY",
                  colors: [0, 0, 0, 0, 0],
                  length: 5,
                ),
              ],
            ),
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Once submitted, a new guess will appear! Use this to solve your Wordle, then input the colors back into the form, submit, and repeat until the word has been found.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        PageViewModel(
          title: "Guess Input",
          image: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                WordleRow(
                  text: "WORDS",
                  colors: [0, 1, 2, 1, 0],
                  length: 5,
                  enabled: false,
                ),
                WordleRow(
                  text: "PARTY",
                  colors: [0, 0, 1, 0, 0],
                  length: 5,
                  enabled: false,
                ),
                WordleRow(
                  text: "XXXXX",
                  colors: [-1, -1, -1, -1, -1],
                  length: 5,
                  enabled: false,
                ),
              ],
            ),
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "If no word was found (usually due to an incorrect input), an error will appear.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        PageViewModel(
          title: "Guess Input",
          image: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                WordleRow(
                  text: "WORDS",
                  colors: [0, 1, 2, 1, 0],
                  length: 5,
                  enabled: false,
                ),
                WordleRow(
                  text: "PARTY",
                  colors: [0, 0, 1, 0, 0],
                  length: 5,
                  enabled: false,
                ),
                WordleRow(
                  text: "EXAMS",
                  colors: [2, 2, 2, 2, 2],
                  length: 5,
                  enabled: false,
                ),
              ],
            ),
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "If the algorithm is certain that it has found the answer, it will make all the boxes green!",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        PageViewModel(
          title: "Resetting the Game",
          image: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                height: 50,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
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
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "You can use either of these buttons to reset the board once you are done, or in case you incorrectly submitted a guess.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        PageViewModel(
          title: "Changing Settings",
          image: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              )
            ],
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "You can press the settings button in the top right to toggle light/dark mode or to change word length.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        PageViewModel(
          title: "Have fun!",
          image: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.help),
              )
            ],
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "If you ever need to come back to this, just press the help icon in the top left.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
