import 'dart:ui';
import 'package:flutter/material.dart';

class SignLanguage extends StatelessWidget {
  const SignLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> alphabets =
        List.generate(26, (index) => String.fromCharCode(97 + index)); // a-z

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Sign Language', style: TextStyle(color: Colors.white)),
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
          // Background
          Image.asset("assets/images/playmenu.png", fit: BoxFit.fill),

          // Alphabet Grid
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: GridView.builder(
              itemCount: alphabets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // adjust for landscape/tablet
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final letter = alphabets[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlphabetScreen(letter: letter),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/sign_tutorial/asl_img/$letter.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class AlphabetScreen extends StatelessWidget {
  final String letter;

  const AlphabetScreen({Key? key, required this.letter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(letter.toUpperCase())),
      body: Center(
        child: Image.asset(
          'assets/images/sign_tutorial/asl_vid/${letter.toUpperCase()}.mp4',
          width: 300,
        ),
      ),
    );
  }
}
