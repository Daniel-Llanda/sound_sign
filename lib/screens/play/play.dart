import 'dart:ui';
import 'package:flutter/material.dart';
import 'sign_language.dart';
import 'sound_awareness.dart';
import 'sign_it_up.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  Widget _buildMenuButton(
    BuildContext context,
    String label,
    String imagePath, // Add image path parameter
    Widget destination,
  ) {
    return SizedBox(
      width: 180,
      height: 160, // increased height to fit image + text
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80, fit: BoxFit.contain),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // allow body to show under AppBar
      appBar: AppBar(
        title: Text(
          'Play Menu',
          style: TextStyle(color: Colors.white), // 👈 Set text color to white
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.1), // semi-transparent
        elevation: 0,
        foregroundColor:
            Colors.white, // 👈 Ensures icons/buttons are also white
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
          Image.asset(
            "assets/images/playmenu.png", // Make sure this path is correct
            fit: BoxFit.fill,
          ),

          // Foreground content
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildMenuButton(
                  context,
                  'Sign\nLanguage',
                  'assets/images/sign_language.png', // image path
                  SingAlongAdventure(),
                ),
                _buildMenuButton(
                  context,
                  'Sound\nAwareness',
                  'assets/images/music.png',
                  SoundAwareness(),
                ),
                _buildMenuButton(
                  context,
                  'Sign It\nUp',
                  'assets/images/interpreter.png',
                  SingItUp(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
