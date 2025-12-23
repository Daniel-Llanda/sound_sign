import 'dart:math';
import 'package:flutter/material.dart';

class HardScreen extends StatefulWidget {
  const HardScreen({super.key});

  @override
  State<HardScreen> createState() => _HardScreenState();
}

class _HardScreenState extends State<HardScreen> {
  bool showInstructions = true;

  final List<String> allLetters = List.generate(26, (i) => String.fromCharCode(65 + i));

  final List<String> words = [
    "APPLE", "HOUSE", "PLANT", "TRAIN", "SWEET",
    "BRUSH", "MOUSE", "LIGHT", "TABLE", "CHAIR",
    "CLOUD", "RIVER", "PLANE", "SHEET", "GLASS",
    "HEART", "SUGAR", "FLOUR", "BREAD", "CLOCK",
  ];

  late List<String> quizWords;
  late List<String> choices;

  int currentIndex = 0;
  int score = 0;
  String userInput = "";

  @override
  void initState() {
    super.initState();
    _generateQuiz();
    _generateChoices();
  }

  void _generateQuiz() {
    words.shuffle(Random());
    quizWords = words.take(5).toList(); // 5 questions
  }

  void _generateChoices() {
    String word = quizWords[currentIndex];
    Set<String> temp = word.split("").toSet();

    List<String> others = List.from(allLetters)..removeWhere((l) => temp.contains(l));
    others.shuffle(Random());

    while (temp.length < 10) {
      temp.add(others.removeAt(0));
    }

    choices = temp.toList()..shuffle(Random());
  }

  void _selectLetter(String letter) {
    if (userInput.length >= 5) return;
    setState(() => userInput += letter);
  }

  void _deleteLetter() {
    if (userInput.isNotEmpty) {
      setState(() => userInput = userInput.substring(0, userInput.length - 1));
    }
  }

  void _clearInput() {
    setState(() => userInput = "");
  }

  void _submitAnswer() {
    if (userInput.length != 5) return;

    String correct = quizWords[currentIndex];
    if (userInput == correct) score++;

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        userInput = "";
        currentIndex++;
        if (currentIndex < quizWords.length) _generateChoices();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hard Level"),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset("assets/images/playmenu.png", fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: showInstructions
                ? _buildInstructions()
                : currentIndex < quizWords.length
                    ? _buildQuiz()
                    : _buildResult(),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "How to Play",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "• Look at the hand sign images\n"
              "• Choose letters to form the 5-letter word\n"
              "• Use Delete or Clear if needed\n"
              "• Press Submit to check your answer",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white, height: 1.5),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => setState(() => showInstructions = false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: const Text("Start Quiz", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    String word = quizWords[currentIndex];

    return Row(
      
      children: [
        // Left: Sign images with slight overlap
     Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Question text on top
                Text(
                  "Question ${currentIndex + 1} of ${quizWords.length}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Sign language images in multiple rows
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4, // horizontal space between images
                  runSpacing: 4, // vertical space between rows
                  children: word.split("").map((letter) {
                    return Image.asset(
                      "assets/images/sign_tutorial/asl_img/${letter.toLowerCase()}.png",
                      height: 100,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // User input container below images
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    userInput.padRight(5, "_"),
                    style: const TextStyle(
                      fontSize: 32,
                      letterSpacing: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),




        // Right: Question info, input, buttons, letter grid
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _deleteLetter,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text("Delete"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _clearInput,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                    child: const Text("Clear"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submitAnswer,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text("Submit"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: choices.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () => _selectLetter(choices[index]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(choices[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Quiz Completed!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 15),
          Text("Your Score: $score / ${quizWords.length}", style: const TextStyle(fontSize: 22, color: Colors.white)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                score = 0;
                currentIndex = 0;
                userInput = "";
                showInstructions = true;
                _generateQuiz();
                _generateChoices();
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16)),
            child: const Text("Play Again", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
