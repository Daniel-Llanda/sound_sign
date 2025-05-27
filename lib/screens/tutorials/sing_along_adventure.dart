import 'package:flutter/material.dart';

class SingAlongAdventure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text('Sing Along Adventure'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Text(
          'Welcome to Sing Along Adventure!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
