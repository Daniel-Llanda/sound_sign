import 'dart:ui';
import 'package:flutter/material.dart';

// Import your game screens
import 'sign_to_text_levels/sign_to_text.dart';

import 'text_to_sign_levels/text_to_sign.dart';
import 'sound_awareness_levels/sound_awareness.dart';

class SingItUp extends StatelessWidget {
  const SingItUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Sign It Up',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.1),
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "assets/images/playmenu.png",
            fit: BoxFit.fill,
          ),

          // Buttons
          Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildGameButton(
                  context,
                  "Sign to Text",
                  const SignToTextScreen(),
                ),
                _buildGameButton(
                  context,
                  "Text to Sign",
                  const TextToSignScreen(),
                ),
                _buildGameButton(
                  context,
                  "Sound Awareness",
                  const SoundAwarenessScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameButton(
    BuildContext context,
    String label,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
