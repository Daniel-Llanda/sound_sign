import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// ================= MODEL =================
class SoundInfo {
  final String title;
  final String imagePath;
  final String soundPath;

  const SoundInfo({
    required this.title,
    required this.imagePath,
    required this.soundPath,
  });
}

// ================= DATA =================
final List<SoundInfo> allSounds = [
  SoundInfo(
    title: 'Ambulance Siren',
    imagePath: 'assets/images/ambulance.png',
    soundPath: 'sounds/ambulance.mp3',
  ),
  SoundInfo(
    title: 'Fire Alarm',
    imagePath: 'assets/images/alarm.png',
    soundPath: 'sounds/alarm.mp3',
  ),
  SoundInfo(
    title: 'Smoke Detector',
    imagePath: 'assets/images/smoke_detector.png',
    soundPath: 'sounds/smoke_detector.mp3',
  ),
  SoundInfo(
    title: 'Doorbell',
    imagePath: 'assets/images/doorbell.png',
    soundPath: 'sounds/doorbell.mp3',
  ),
  SoundInfo(
    title: 'Phone Ringing',
    imagePath: 'assets/images/telephone_call.png',
    soundPath: 'sounds/telephone_ring.mp3',
  ),
  SoundInfo(
    title: 'Car Horn',
    imagePath: 'assets/images/horn.png',
    soundPath: 'sounds/horn.mp3',
  ),
  SoundInfo(
    title: 'Baby Crying',
    imagePath: 'assets/images/baby.png',
    soundPath: 'sounds/baby.mp3',
  ),
  SoundInfo(
    title: 'Alarm Clock',
    imagePath: 'assets/images/alarm_clock.png',
    soundPath: 'sounds/alarm_clock.mp3',
  ),
];

// ================= SCREEN =================
class SoundAwarenessMedium extends StatefulWidget {
  const SoundAwarenessMedium({super.key});

  @override
  State<SoundAwarenessMedium> createState() => _SoundAwarenessMediumState();
}

class _SoundAwarenessMediumState extends State<SoundAwarenessMedium> {
  final AudioPlayer player = AudioPlayer();

  bool showInstructions = true;

  late List<SoundInfo> quizSounds;
  late List<SoundInfo> choices;

  int currentIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _generateQuiz();
    _generateChoices();
  }

  // ================= QUIZ GENERATION =================
  void _generateQuiz() {
    final random = Random();

    // 10 questions for MEDIUM
    quizSounds = List.generate(
      10,
      (_) => allSounds[random.nextInt(allSounds.length)],
    );
  }

  void _generateChoices() {
    SoundInfo correct = quizSounds[currentIndex];
    List<SoundInfo> temp = List.from(allSounds)..remove(correct);
    temp.shuffle(Random());

    choices = temp.take(3).toList();
    choices.add(correct);
    choices.shuffle(Random());

    if (!showInstructions) {
      player.stop();
      player.play(AssetSource(correct.soundPath));
    }
  }

  void _selectAnswer(SoundInfo selected) {
    SoundInfo correct = quizSounds[currentIndex];

    if (selected.title == correct.title) {
      score++;
    }

    setState(() {
      currentIndex++;
      if (currentIndex < quizSounds.length) {
        _generateChoices();
      } else {
        player.stop();
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sound Awareness – Medium"),
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
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
            padding: const EdgeInsets.all(16.0),
            child: showInstructions
                ? _buildInstructions()
                : currentIndex < quizSounds.length
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
            "• Listen to the sound\n"
            "• Look at the image\n"
            "• Choose the correct answer\n"
            "• 10 questions total",
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

              player.play(
                AssetSource(quizSounds[currentIndex].soundPath),
              );
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
    SoundInfo current = quizSounds[currentIndex];

    return Row(
      children: [
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () {
                player.play(AssetSource(current.soundPath));
              },
              child: Image.asset(
                current.imagePath,
                height: 200,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Question ${currentIndex + 1} of 10",
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
                      choices[index].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
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
            "Your Score: $score / 10",
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
