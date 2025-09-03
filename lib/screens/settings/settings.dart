import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("Close"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  Widget _buildButton(BuildContext context, String title, String message) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25, // ✅ 70% of screen width
      child: ElevatedButton(
        onPressed: () => _showDialog(context, title, message),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ["Sign Language", "Sign language settings and info go here."],
      ["Audio/Sound", "Audio and sound settings go here."],
      ["Keyboard", "Keyboard settings and shortcuts go here."],
      [
        "About Us",
        "This app was developed to make learning fun and interactive!",
      ],
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
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
          Image.asset('assets/images/settingsmenu.png', fit: BoxFit.fill),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // generate all buttons with one loop
                ...buttons.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _buildButton(context, b[0], b[1]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
