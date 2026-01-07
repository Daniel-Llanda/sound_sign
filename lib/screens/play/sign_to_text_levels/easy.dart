import 'dart:math';
import 'package:flutter/material.dart';

class EasyScreen extends StatefulWidget {
  const EasyScreen({super.key});

  @override
  State<EasyScreen> createState() => _EasyScreenState();
}

class _EasyScreenState extends State<EasyScreen> {
  bool showInstructions = true;

  final List<String> allLetters =
      List.generate(26, (i) => String.fromCharCode(65 + i));

  late List<String> quizLetters;
  late List<String> choices;

  int currentIndex = 0;
  int score = 0;
  List<String> userAnswers = [];

  @override
  void initState() {
    super.initState();
    _generateQuiz();
    _generateChoices();
  }

  void _generateQuiz() {
    allLetters.shuffle(Random());
    quizLetters = allLetters.take(5).toList();
  }

  void _generateChoices() {
    String correct = quizLetters[currentIndex];
    List<String> temp = List.from(allLetters)..remove(correct);
    temp.shuffle(Random());

    choices = temp.take(3).toList();
    choices.add(correct);
    choices.shuffle(Random());
  }

  void _selectAnswer(String selected) {
    String correct = quizLetters[currentIndex];
    userAnswers.add(selected);

    if (selected == correct) {
      score++;
    }

    setState(() {
      currentIndex++;
      if (currentIndex < quizLetters.length) {
        _generateChoices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Easy Level"),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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

          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: showInstructions
                ? _buildInstructions()
                : currentIndex < quizLetters.length
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
            "• Look at the hand sign image\n"
            "• Choose the correct letter\n"
            "• Tap the answer to continue\n"
            "• Try to get all correct!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              setState(() {
                showInstructions = false;
              });
            },
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
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              "assets/images/sign_language/${quizLetters[currentIndex].toLowerCase()}.png",
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Question ${currentIndex + 1} of ${quizLetters.length}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              GridView.builder(
                shrinkWrap: true,
                itemCount: choices.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 2,
                ),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _selectAnswer(choices[index]),
                    child: Text(
                      choices[index],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
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
    // Get wrong answers
    List<Map<String, String>> wrongAnswers = [];

    for (int i = 0; i < quizLetters.length; i++) {
      if (userAnswers[i] != quizLetters[i]) {
        wrongAnswers.add({
          "question": (i + 1).toString(),
          "correct": quizLetters[i],
          "your": userAnswers[i],
        });
      }
    }

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
            const SizedBox(height: 10),
            Text(
              "Your Score: $score / ${quizLetters.length}",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),

            // ===== SHOW WRONG ANSWERS =====
            if (wrongAnswers.isNotEmpty) ...[
              const SizedBox(height: 25),
              const Text(
                "Wrong Answers",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 10),

              ...wrongAnswers.map((item) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.close, color: Colors.red),
                    title: Text(
                      "Question ${item["question"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Your answer: ${item["your"]}\nCorrect answer: ${item["correct"]}",
                    ),
                  ),
                );
              }).toList(),
            ],

            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
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
