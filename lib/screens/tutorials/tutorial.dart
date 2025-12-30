import 'dart:ui';
import 'package:flutter/material.dart';
import 'sign_language.dart';
import 'sign_it_up.dart';

class TutorialsScreen extends StatelessWidget {
  const TutorialsScreen({super.key});

  Widget _buildNavigationButton(
    BuildContext context,
    String label,
    Widget destination,
  ) {
    return SizedBox(
      width: 220,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue, // solid button color
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Tutorials', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent, // make appbar transparent
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "assets/images/tutorialmenu.png", // update path if needed
            fit: BoxFit.fill,
          ),

          // Full-screen glass effect
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.2), // semi-transparent overlay
              ),
            ),
          ),

          // Foreground content (buttons)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                _buildNavigationButton(
                  context,
                  'AMERICAN SIGN LANGUAGE',
                  SignLanguage(),
                ),
                const SizedBox(height: 10),
                _buildNavigationButton(
                  context,
                  'SIGN IT UP',
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
