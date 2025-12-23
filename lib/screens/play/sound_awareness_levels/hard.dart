import 'package:flutter/material.dart';

class Level3Screen extends StatelessWidget {
  const Level3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Level 3")),
      body: const Center(
        child: Text("🎶 Welcome to Level 3!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
