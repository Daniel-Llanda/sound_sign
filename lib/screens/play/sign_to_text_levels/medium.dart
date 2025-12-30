import 'dart:math';
import 'package:flutter/material.dart';

class MediumScreen extends StatefulWidget {
  const MediumScreen({super.key});

  @override
  State<MediumScreen> createState() => _MediumScreenState();
}

class _MediumScreenState extends State<MediumScreen> {
  bool showInstructions = true;

  final List<String> allLetters =
      List.generate(26, (i) => String.fromCharCode(65 + i));

  final List<String> words = [
    "DOG", "CAT", "SUN", "BAT", "HAT", "CAR", "PEN", "BOX",
    "COW", "PIG", "RAT", "FOX", "HEN",
    "CUP", "BAG", "BED", "TOY", "MAP",
    "SKY", "SEA", "ICE", "LOG", "ANT",
    "RUN", "SIT", "EAT",
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
    quizWords = words.take(5).toList();
  }

  void _generateChoices() {
    String word = quizWords[currentIndex];
    Set<String> temp = word.split("").toSet();

    List<String> others =
        List.from(allLetters)..removeWhere((l) => temp.contains(l));
    others.shuffle(Random());

    while (temp.length < 5) {
      temp.add(others.removeAt(0));
    }

    choices = temp.toList()..shuffle(Random());
  }

  void _selectLetter(String letter) {
    if (userInput.length >= 3) return;
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
    if (userInput.length != 3) return;

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
        title: const Text("Medium Level"),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
            ),
          ),
          // Texture overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                "assets/images/playmenu.png",
                fit: BoxFit.cover,
              ),
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

  // ================= INSTRUCTIONS =================
  Widget _buildInstructions() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "How to Play",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "• Look at the sign images\n"
            "• Choose letters to form the 3-letter word\n"
            "• Use Delete or Clear if needed\n"
            "• Press Submit to check your answer",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() => showInstructions = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text(
              "Start Quiz",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= QUIZ =================
  Widget _buildQuiz() {
    String word = quizWords[currentIndex];

    return Row(
      children: [
        // Left side: Sign images
        Expanded(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: word.split("").map((letter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Image.asset(
                    "assets/images/sign_tutorial/asl_img/${letter.toLowerCase()}.png",
                    height: 100,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Right side: Question, input, buttons, choices
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Question ${currentIndex + 1} of ${quizWords.length}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Selected letters display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  userInput.padRight(3, "_"),
                  style: const TextStyle(
                    fontSize: 32,
                    letterSpacing: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _deleteLetter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white, // 👈 white text
                    ),
                    child: const Text("Delete"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _clearInput,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white, // 👈 white text
                    ),
                    child: const Text("Clear"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submitAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white, // 👈 white text
                    ),
                    child: const Text("Submit"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Letter choices grid
              Center(
                child: SizedBox(
                  width: 300,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: choices.length,
                    physics: const NeverScrollableScrollPhysics(),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          choices[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= RESULT =================
  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Quiz Completed!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Your Score: $score / ${quizWords.length}",
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
           ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, true); // Marks Easy as finished
            },
            child: const Text(
              "Finish",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
