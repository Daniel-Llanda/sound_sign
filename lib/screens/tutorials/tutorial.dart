import 'package:flutter/material.dart';
import 'sing_along_adventure.dart';
import 'sing_it_up.dart';

class TutorialsScreen extends StatelessWidget {
  const TutorialsScreen({super.key});

  Widget _buildNavigationButton(
    BuildContext context,
    String label,
    Widget destination,
  ) {
    return SizedBox(
      width: 220,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text('Tutorials'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome to Tutorials',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 20),
            _buildNavigationButton(
              context,
              'SING ALONG ADVENTURE',
              SingAlongAdventure(),
            ),
            SizedBox(height: 10),
            _buildNavigationButton(context, 'SING IT UP', SingItUp()),
          ],
        ),
      ),
    );
  }
}
