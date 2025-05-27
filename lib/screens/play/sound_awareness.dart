import 'dart:ui';
import 'package:flutter/material.dart';

class SoundAwareness extends StatelessWidget {
  const SoundAwareness({super.key});

  Widget _buildBox(String label) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Sound Awareness', style: TextStyle(color: Colors.white)),
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
            "assets/images/playmenu.png", // Replace with your actual image path
            fit: BoxFit.fill,
          ),

          // Foreground content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to Sound Awareness!',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20),
                // First row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBox('Box 1'),
                    _buildBox('Box 2'),
                    _buildBox('Box 3'),
                    _buildBox('Box 3'),
                  ],
                ),
                // Second row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBox('Box 4'),
                    _buildBox('Box 5'),
                    _buildBox('Box 6'),
                    _buildBox('Box 6'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
