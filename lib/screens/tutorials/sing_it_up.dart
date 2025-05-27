import 'package:flutter/material.dart';

class SingItUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text('Sing It Up'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Text(
          'Welcome to Sing It Up!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
