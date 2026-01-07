import 'dart:math';
import 'package:flutter/material.dart';

class TEasyScreen extends StatefulWidget {
  const TEasyScreen({super.key});

  @override
  State<TEasyScreen> createState() => _EasyScreenState();
}

class _EasyScreenState extends State<TEasyScreen> {
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
            "• Look at the letter shown\n"
            "• Choose the correct hand sign image\n"
            "• Tap the image to continue\n"
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
        // LETTER DISPLAY
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                quizLetters[currentIndex],
                style: const TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),

        // IMAGE CHOICES
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
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _selectAnswer(choices[index]),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        "assets/images/sign_tutorial/asl_img/${choices[index].toLowerCase()}.png",
                        fit: BoxFit.contain,
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
    // Collect wrong answers
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

            // ===== WRONG ANSWERS =====
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
              const SizedBox(height: 15),

              ...wrongAnswers.map((item) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question ${item["question"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // ❌ User answer
                            Column(
                              children: [
                                const Text("Your Answer",
                                    style: TextStyle(color: Colors.red)),
                                const SizedBox(height: 6),
                                Image.asset(
                                  "assets/images/sign_tutorial/asl_img/${item["your"]!.toLowerCase()}.png",
                                  height: 70,
                                ),
                              ],
                            ),

                            // ✅ Correct answer
                            Column(
                              children: [
                                const Text("Correct",
                                    style: TextStyle(color: Colors.green)),
                                const SizedBox(height: 6),
                                Image.asset(
                                  "assets/images/sign_tutorial/asl_img/${item["correct"]!.toLowerCase()}.png",
                                  height: 70,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
