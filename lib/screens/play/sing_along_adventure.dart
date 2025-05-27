import 'dart:ui';
import 'package:flutter/material.dart';

class SingAlongAdventure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // allows the body to go under the AppBar
      appBar: AppBar(
        title: Text(
          'Sing Along Adventure',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.1), // semi-transparent
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
            "assets/images/playmenu.png", // Replace with your actual image path
            fit: BoxFit.fill,
          ),

          // Foreground content
          Center(
            child: Text(
              'Welcome to Sing Along Adventure!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
