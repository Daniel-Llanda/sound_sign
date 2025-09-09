import 'package:flutter/material.dart';

class Level2Screen extends StatelessWidget {
  const Level2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Level 2")),
      body: const Center(
        child: Text("🎶 Welcome to Level 2!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
