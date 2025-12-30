import 'dart:ui';
import 'package:flutter/material.dart';

import 'sign_language.dart';
import 'sound_awareness.dart';
import 'sign_it_up.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 🌈 Background Image
        Image.asset(
          "assets/images/playmenu.png",
          fit: BoxFit.fill,
        ),

        // 💨 Glass Effect Overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.white.withOpacity(0.1), // semi-transparent overlay
          ),
        ),

        // 🏗 Scaffold on top for AppBar & Buttons
        Scaffold(
          backgroundColor: Colors.transparent, // Make Scaffold transparent
          extendBodyBehindAppBar: true,
         appBar: AppBar(
            title: const Text(
              'Play Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.white, // <-- sets back button color to white
            ),
          ),

          body: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: const [
                _KidMenuButton(
                  label: "Sign\nLanguage",
                  imagePath: "assets/images/sign_language.png",
                  colors: [Colors.orange, Colors.deepOrange],
                  destination: SingAlongAdventure(),
                ),
                _KidMenuButton(
                  label: "Sound\nAwareness",
                  imagePath: "assets/images/music.png",
                  colors: [Colors.pink, Colors.purple],
                  destination: SoundAwareness(),
                ),
                _KidMenuButton(
                  label: "Sign It\nUp",
                  imagePath: "assets/images/interpreter.png",
                  colors: [Colors.lightBlue, Colors.blueAccent],
                  destination: SingItUp(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// 🎉 KID-FRIENDLY MENU BUTTON WITH BOUNCE
// ======================================================

class _KidMenuButton extends StatefulWidget {
  final String label;
  final String imagePath;
  final List<Color> colors;
  final Widget destination;

  const _KidMenuButton({
    required this.label,
    required this.imagePath,
    required this.colors,
    required this.destination,
  });

  @override
  State<_KidMenuButton> createState() => _KidMenuButtonState();
}

class _KidMenuButtonState extends State<_KidMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.12,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => widget.destination),
        );
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1 - _controller.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          width: 180,
          height: 170,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.imagePath,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
