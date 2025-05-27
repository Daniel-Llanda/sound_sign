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
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text('Sound Awareness'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
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
              ],
            ),
            // Second row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBox('Box 4'),
                _buildBox('Box 5'),
                _buildBox('Box 6'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
