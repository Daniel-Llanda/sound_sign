import 'dart:math';
import 'package:flutter/material.dart';

class TMediumScreen extends StatefulWidget {
  const TMediumScreen({super.key});

  @override
  State<TMediumScreen> createState() => _MediumScreenState();
}

class _MediumScreenState extends State<TMediumScreen> {
  bool showInstructions = true;

  final List<String> allLetters =
      List.generate(26, (i) => String.fromCharCode(65 + i));
  List<String> userAnswers = []; // Track user inputs


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

    while (temp.length < 6) {
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

    // Save the user's answer
    userAnswers.add(userInput);

    String correct = quizWords[currentIndex];
    if (userInput == correct) score++;

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        userInput = "";
        currentIndex++;
        if (currentIndex < quizWords.length) {
          _generateChoices();
        }
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
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
            ),
          ),
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
            "• Look at the word shown\n"
            "• Tap the correct sign images\n"
            "• Build the 3-letter word\n"
            "• Press Submit to check",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => setState(() => showInstructions = false),
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
       Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ===== QUESTION TITLE =====
              Text(
                "Question ${currentIndex + 1} of ${quizWords.length}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              // ===== WORD DISPLAY =====
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  word,
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 6,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===== USER INPUT DISPLAY =====
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
            ],
          ),
        ),


        // ===== IMAGE CHOICES =====
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _deleteLetter,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, ),
                    child: const Text("Delete"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _clearInput,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, ),
                    child: const Text("Clear"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submitAnswer,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, ),
                    child: const Text("Submit"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // IMAGE GRID
              GridView.builder(
                shrinkWrap: true,
                itemCount: choices.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100, // Max width of each box
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,      // Square boxes
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _selectLetter(choices[index]),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/images/sign_tutorial/asl_img/${choices[index].toLowerCase()}.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),



            ],
          ),
        ),
      ],
    );
  }

  // ================= RESULT =================
  Widget _buildResult() {
    return SingleChildScrollView(
      child: Center(
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

            // Show wrong answers
            Column(
              children: List.generate(quizWords.length, (index) {
                bool isCorrect = userAnswers[index] == quizWords[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    isCorrect
                        ? "${index + 1}. Correct: ${quizWords[index]}"
                        : "${index + 1}. Your answer: ${userAnswers[index]} ❌ | Correct: ${quizWords[index]}",
                    style: TextStyle(
                      fontSize: 18,
                      color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                );
              }),
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
                Navigator.pop(context, true); // Marks Medium as finished
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
      ),
    );
  }

}
