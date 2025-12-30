import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import level screens
import 'easy.dart';
import 'medium.dart';
import 'hard.dart';

class SoundAwarenessScreen extends StatefulWidget {
  const SoundAwarenessScreen({super.key});

  @override
  State<SoundAwarenessScreen> createState() => _SoundAwarenessScreenState();
}

class _SoundAwarenessScreenState extends State<SoundAwarenessScreen> {
  bool easyDone = false;
  bool mediumDone = false;
  bool hardDone = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      easyDone = prefs.getBool('sound_easyDone') ?? false;
      mediumDone = prefs.getBool('sound_mediumDone') ?? false;
      hardDone = prefs.getBool('sound_hardDone') ?? false;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_easyDone', easyDone);
    await prefs.setBool('sound_mediumDone', mediumDone);
    await prefs.setBool('sound_hardDone', hardDone);
  }

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
        title: const Text('Sound Awareness'),
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
                  const SoundAwarenessEasy(),
                  Colors.green,
                  enabled: true,
                  showStar: easyDone,
                  onFinished: () => _markLevelDone('easy'),
                ),
                const SizedBox(height: 15),
                _buildLevelButton(
                  context,
                  'Medium',
                  const SoundAwarenessMedium(),
                  Colors.orange,
                  enabled: easyDone,
                  showStar: mediumDone,
                  onFinished: () => _markLevelDone('medium'),
                ),
                const SizedBox(height: 15),
                _buildLevelButton(
                  context,
                  'Hard',
                  const SoundAwarenessHard(),
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
                if (result == true) onFinished();
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
