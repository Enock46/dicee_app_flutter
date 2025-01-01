import 'package:dicee/auth_pages/login.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const Dicee());
}

class Dicee extends StatefulWidget {
  const Dicee({super.key});

  @override
  State<Dicee> createState() => _DiceeState();
}

class _DiceeState extends State<Dicee> {
  int mainDicee = 0;
  String message = '';
  double balance = 40;
  double lotSize = 0.50;
  bool buttonsDisabled = false;

  final player = AudioPlayer();

  @override
  void dispose() {
    super.dispose();
    player.dispose(); // Dispose of the player when no longer needed
  }

  void playSound(String musicType) async {
    await player.setAsset('assets/$musicType.mp3');
    await player.play();
  }

  //refresh function
  void rolling() {
    setState(() {
      mainDicee = 0;
      message = 'Dice Rolling...';
    });
  }

  //main comparing function
  void mainDiceeChange(int playerChoice) {
    setState(() {
      mainDicee = Random().nextInt(6) + 1;
      //check for matched dicee
      if (playerChoice == mainDicee) {
        playSound('win');
        message = 'Congratulation! Win';

        if (balance > 0) {
          balance = balance + (1.86 * lotSize);
        } else {
          balance = 0;
          message = 'Unsatified Amount ';
        }
      } else {
        playSound('loss');
        message = 'Sorry, You Lose. Try Again';

        if (balance > 0.5) {
          balance = balance - (1 * lotSize);
        } else if (balance < 0.5) {
          balance = 0;
          message = 'Unsatified Amount';
        }
      }
    });
  }

//increment function
  void incrementLotSize() {
    setState(() {
      if (lotSize < 6) {
        lotSize += 0.50;
      }
    });
  }

//decrement function
  void decrementLotSize() {
    setState(() {
      if (lotSize > 0.50) {
        lotSize -= 0.50;
      }
    });
  }

  //Builder collapsed function

  Expanded buildDice({required int diceNumber, required int choiceNumber}) {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
            Color.fromARGB(255, 98, 140, 136),
          ),
        ),
        child: Image.asset(
          'lib/images/dice$diceNumber.png',
        ),
        onPressed: () {
          if (!buttonsDisabled) {
            rolling();
            // First function

            setState(() {
              buttonsDisabled = true; // Disable buttons
            });

            Future.delayed(const Duration(seconds: 5), () {
              // This code will run 5 seconds later
              mainDiceeChange(choiceNumber); // Second function

              setState(() {
                buttonsDisabled = false; // Enable buttons again
              });
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(42, 0, 0, 0),
          leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                //move to another page

                const Login();
              }),
          title: const Text(
            "Money Dice play",
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            // Current Balance
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.monetization_on_outlined,
                size: 20,
              ),
            ),
            //balance button
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 15.0),
              child: Text(
                balance.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            //restart button (refreshing)
            IconButton(
              onPressed: () {
                setState(() {
                  lotSize = 0.50;
                  mainDicee = 0;
                  message = 'Refreshed';
                });
              },
              icon: const Icon(
                Icons.restart_alt_rounded,
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // display win or loss massage
              Column(
                children: [
                  const Text(
                    'Lotsize',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //decrementlotsize
                      IconButton(
                        onPressed: () {
                          decrementLotSize();
                        },
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 25),
                      //Lotsize
                      Text(
                        lotSize.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 25),
                      //incrementLT
                      IconButton(
                        onPressed: () {
                          incrementLotSize();
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // Display the message
              Text(
                message,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 15),
              //main  dice to compare
              Expanded(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                      Colors.teal,
                    ),
                  ),
                  onPressed: null,
                  child: Image.asset(
                    'lib/images/dice$mainDicee.png',
                  ),
                ),
              ),
              const SizedBox(height: 50),
              //Culomn 1 and user click dicees
              Row(
                children: [
                  //left dicee C1
                  buildDice(diceNumber: 1, choiceNumber: 1),

                  const SizedBox(width: 25),
                  //right dicee C1
                  buildDice(diceNumber: 2, choiceNumber: 2),
                ],
              ),
              //column 2
              const SizedBox(height: 25),
              Row(
                children: [
                  //left dicee C2
                  buildDice(diceNumber: 3, choiceNumber: 3),
                  const SizedBox(width: 25),
                  //right dicee C2
                  buildDice(diceNumber: 4, choiceNumber: 4),
                ],
              ),
              //COlumn 3
              const SizedBox(height: 25),
              Row(
                children: [
                  //left dicee C3
                  buildDice(diceNumber: 5, choiceNumber: 5),
                  const SizedBox(width: 25),
                  //right dicee C3
                  buildDice(diceNumber: 6, choiceNumber: 6),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
