import 'dart:math';
import 'package:flutter/material.dart';

class Level1Screen extends StatefulWidget {
  const Level1Screen({super.key});

  @override
  State<Level1Screen> createState() => _Level1ScreenState();
}

class _Level1ScreenState extends State<Level1Screen> {
  final List<String> allLetters = List.generate(
    26,
    (i) => String.fromCharCode(65 + i),
  ); // A–Z
  late List<String> quizLetters;
  int currentIndex = 0;
  int score = 0;
  String userAnswer = "";
  List<String> userAnswers = [];

  final TextEditingController _controller =
      TextEditingController(); // ✅ Controller

  @override
  void initState() {
    super.initState();
    _generateQuiz();
  }

  void _generateQuiz() {
    allLetters.shuffle(Random());
    quizLetters = allLetters.take(5).toList(); // Pick 5 random letters
  }

  void _submitAnswer() {
    if (userAnswer.trim().isEmpty) return;

    String correct = quizLetters[currentIndex];
    userAnswers.add(userAnswer.toUpperCase());

    if (userAnswer.toUpperCase() == correct) {
      score++;
    }

    setState(() {
      userAnswer = "";
      _controller.clear(); // ✅ Clears input field
      currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        title: const Text("Level 1 - Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            currentIndex < quizLetters.length
                ? Row(
                  children: [
                    // Left Side - Image
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Image.asset(
                          "assets/images/sign_language/${quizLetters[currentIndex].toLowerCase()}.png",
                          height: 300,
                          width: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Right Side - Question + Input + Button
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Question ${currentIndex + 1} of ${quizLetters.length}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _controller, // ✅ Added
                              onChanged: (value) => userAnswer = value,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Enter the letter",
                              ),
                            ),

                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: _submitAnswer,
                              child: const Text("Submit"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : _buildResult(),
      ),
    );
  }

  Widget _buildResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Quiz Completed!",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          "Your Score: $score / ${quizLetters.length}",
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: quizLetters.length,
            itemBuilder: (context, index) {
              String correct = quizLetters[index];
              String user = userAnswers[index];
              return ListTile(
                leading: Image.asset(
                  "assets/images/sign_language/$correct.jpg",
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                title: Text("Correct: $correct"),
                subtitle: Text("Your Answer: $user"),
                trailing: Icon(
                  user == correct ? Icons.check : Icons.close,
                  color: user == correct ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
          onPressed: () {
            setState(() {
              score = 0;
              currentIndex = 0;
              userAnswers.clear();
              _generateQuiz();
            });
          },
          child: const Text("Play Again"),
        ),
      ],
    );
  }
}
