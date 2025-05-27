import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow content behind app bar
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(
          0.1,
        ), // semi-transparent glass effect
        elevation: 0,
        foregroundColor: Colors.white, // makes icons (like back button) white
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
            'assets/images/settingsmenu.png', // ✅ Replace with your actual background image
            fit: BoxFit.fill,
          ),
          const Center(
            child: Text(
              'Welcome to Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
