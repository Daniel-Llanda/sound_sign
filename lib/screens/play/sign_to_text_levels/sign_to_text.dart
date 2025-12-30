import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import level screens
import 'easy.dart';
import 'medium.dart';
import 'hard.dart';

class SignToTextScreen extends StatefulWidget {
  const SignToTextScreen({super.key});

  @override
  State<SignToTextScreen> createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen> {
  bool easyDone = false;
  bool mediumDone = false;
  bool hardDone = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // Load saved progress from SharedPreferences
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      easyDone = prefs.getBool('easyDone') ?? false;
      mediumDone = prefs.getBool('mediumDone') ?? false;
      hardDone = prefs.getBool('hardDone') ?? false;
    });
  }

  // Save progress to SharedPreferences
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('easyDone', easyDone);
    await prefs.setBool('mediumDone', mediumDone);
    await prefs.setBool('hardDone', hardDone);
  }

  // Mark level as finished and save
  void _markLevelDone(String level) {
    setState(() {
      if (level == 'easy') easyDone = true;
      if (level == 'medium') mediumDone = true;
      if (level == 'hard') hardDone = true;
    });
    _saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign to Text'),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLevelButton(
                  context,
                  'Easy',
                  const EasyScreen(),
                  Colors.green,
                  enabled: true,
                  showStar: easyDone,
                  onFinished: () => _markLevelDone('easy'),
                ),
                const SizedBox(height: 15),
                _buildLevelButton(
                  context,
                  'Medium',
                  const MediumScreen(),
                  Colors.orange,
                  enabled: easyDone,
                  showStar: mediumDone,
                  onFinished: () => _markLevelDone('medium'),
                ),
                const SizedBox(height: 15),
                _buildLevelButton(
                  context,
                  'Hard',
                  const HardScreen(),
                  Colors.red,
                  enabled: mediumDone,
                  showStar: hardDone,
                  onFinished: () => _markLevelDone('hard'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(
    BuildContext context,
    String label,
    Widget screen,
    Color color, {
    required bool enabled,
    required bool showStar,
    required VoidCallback onFinished,
  }) {
    return SizedBox(
      width: 220,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: enabled
            ? () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => screen),
                );
                if (result == true) {
                  onFinished();
                }
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (showStar) ...[
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.yellow),
            ],
          ],
        ),
      ),
    );
  }
}
