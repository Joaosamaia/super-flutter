import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool oTurn = true;
  List<String> displayXO = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    ''
  ];
  List<int> matchedIndexes = [];
  int attempts = 0;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String resultDeclaration = '';
  bool winnerFound = false;

  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Color(0xff000000),
      letterSpacing: 3,
      fontSize: 25,
    ),
  );

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          resultDeclaration = "Time's up!";
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Tic Tac Toe 4x4',
              style: GoogleFonts.coiny(
                textStyle: const TextStyle(
                  color: Color(0xff000000),
                  letterSpacing: 3.5,
                  fontSize: 25,
                  decorationColor: Color(0xffffffff),
                  decoration: TextDecoration.underline,
                  decorationThickness: 3.0,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Player O',
                        style: customFontWhite,
                      ),
                      Text(
                        oScore.toString(),
                        style: customFontWhite,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Player X',
                        style: customFontWhite,
                      ),
                      Text(
                        xScore.toString(),
                        style: customFontWhite,
                      ),
                    ],
                  ),
                ],
              )),
            ),
            Expanded(
              flex: 4,
              child: GridView.builder(
                  itemCount: 16,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _tapped(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          backgroundBlendMode: BlendMode.hue,
                          border: Border.all(
                            width: 0.8,
                            color: MainColor.accentColor,
                          ),
                          color: matchedIndexes.contains(index)
                              ? MainColor.accentColor
                              : MainColor.secondaryColor,
                        ),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            displayXO[index],
                            style: GoogleFonts.coiny(
                                textStyle: TextStyle(
                              height: 1.5,
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: matchedIndexes.contains(index)
                                  ? MainColor.secondaryColor
                                  : MainColor.primaryColor,
                            )),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(resultDeclaration, style: customFontWhite),
                    const SizedBox(height: 0),
                    _buildTimer()
                  ],
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.network(
                    'https://www.accenture.com/content/dam/accenture/final/images/icons/symbol/Acc_Logo_Black_Purple_RGB.png',
                    width: 100,
                    height: 58,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    'https://www.portodigital.org/_nuxt/img/logo.9d0ef93.svg',
                    width: 100,
                    height: 58,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.network(
                    'https://ficr.catolica.edu.br/portal/wp-content/uploads/2019/06/recife-sigla.svg',
                    width: 100,
                    height: 58,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      setState(() {
        if (oTurn && displayXO[index] == '') {
          displayXO[index] = 'O';
          filledBoxes++;
        } else if (!oTurn && displayXO[index] == '') {
          displayXO[index] = 'X';
          filledBoxes++;
        }

        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    // check 1st row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] == displayXO[3] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[0]} Won!';
        matchedIndexes.addAll([0, 1, 2, 3]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

    // check 2nd row
    else if (displayXO[4] == displayXO[5] &&
        displayXO[4] == displayXO[6] &&
        displayXO[4] == displayXO[7] &&
        displayXO[4] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[4]} Won!';
        matchedIndexes.addAll([4, 5, 6, 7]);
        stopTimer();
        _updateScore(displayXO[4]);
      });
    }

    // check 3rd row
    else if (displayXO[8] == displayXO[9] &&
        displayXO[8] == displayXO[10] &&
        displayXO[8] == displayXO[11] &&
        displayXO[8] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[8]} Won!';
        matchedIndexes.addAll([8, 9, 10, 11]);
        stopTimer();
        _updateScore(displayXO[8]);
      });
    }

    // check 4rd row
    else if (displayXO[12] == displayXO[13] &&
        displayXO[12] == displayXO[14] &&
        displayXO[12] == displayXO[15] &&
        displayXO[12] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[12]} Won!';
        matchedIndexes.addAll([12, 13, 14, 15]);
        stopTimer();
        _updateScore(displayXO[12]);
      });
    }

    // check 1st column
    else if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] == displayXO[12] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[0]} Won!';
        matchedIndexes.addAll([0, 4, 8, 12]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

    // check 2nd column
    else if (displayXO[1] == displayXO[5] &&
        displayXO[1] == displayXO[9] &&
        displayXO[1] == displayXO[13] &&
        displayXO[1] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[1]} Won!';
        matchedIndexes.addAll([1, 5, 9, 13]);
        stopTimer();
        _updateScore(displayXO[1]);
      });
    }

    // check 3rd column
    else if (displayXO[2] == displayXO[6] &&
        displayXO[2] == displayXO[10] &&
        displayXO[2] == displayXO[14] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[2]} Won!';
        matchedIndexes.addAll([2, 6, 10, 14]);
        stopTimer();
        _updateScore(displayXO[2]);
      });
    }

    // check 4rd column
    else if (displayXO[3] == displayXO[7] &&
        displayXO[3] == displayXO[11] &&
        displayXO[3] == displayXO[15] &&
        displayXO[3] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[3]} Won!';
        matchedIndexes.addAll([3, 7, 11, 15]);
        stopTimer();
        _updateScore(displayXO[3]);
      });
    }

    // check 1st diagonal
    else if (displayXO[0] == displayXO[5] &&
        displayXO[0] == displayXO[10] &&
        displayXO[0] == displayXO[15] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[0]} Won!';
        matchedIndexes.addAll([0, 5, 10, 15]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

    // check 2nd diagonal
    else if (displayXO[12] == displayXO[9] &&
        displayXO[12] == displayXO[6] &&
        displayXO[12] == displayXO[3] &&
        displayXO[12] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[12]} Won!';
        matchedIndexes.addAll([12, 9, 6, 3]);
        stopTimer();
        _updateScore(displayXO[12]);
      });
    } else if (filledBoxes == 16) {
      resultDeclaration = 'Neither player won!';
      stopTimer();
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 16; i++) {
        displayXO[i] = '';
      }
      resultDeclaration = '';
      matchedIndexes = [];
    });
    filledBoxes = 0;
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? Container(
            width: 68,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: const AlwaysStoppedAnimation(Color(0xffEBEBEB)),
                  strokeWidth: 9,
                  backgroundColor: MainColor.accentColor,
                ),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    '$seconds',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                      fontSize: 40,
                      height: 1.27,
                    ),
                  ),
                ),
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffB3EFB2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8)),
            onPressed: () {
              startTimer();
              _clearBoard();
              attempts++;
            },
            child: Text(
              attempts == 0 ? 'Play' : 'Play again!',
              style: const TextStyle(
                  fontSize: 20, height: 2, color: Color(0xff000000)),
            ),
          );
  }
}
