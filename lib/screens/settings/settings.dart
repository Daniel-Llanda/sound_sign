import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _currentVolume = 0.5; // default

  @override
  void initState() {
    super.initState();
    // Get initial volume
    VolumeController().getVolume().then((vol) {
      setState(() => _currentVolume = vol);
    });

    // Listen to volume changes (e.g. hardware buttons)
    VolumeController().listener((vol) {
      setState(() => _currentVolume = vol);
    });
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  void _showAudioDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Audio",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Adjust the volume:"),
            Slider(
              value: _currentVolume,
              min: 0,
              max: 1,
              divisions: 100, // smoother sliding
              label: "${(_currentVolume * 100).round()}%",
              onChanged: (value) {
                setState(() => _currentVolume = value);
                VolumeController().setVolume(value); // updates in real-time
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, String message) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        onPressed: () {
          if (title == "Audio") {
            _showAudioDialog(context);
          } else {
            _showDialog(context, title, message);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue, // solid color
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }


  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ["Audio", "Audio settings go here."],
      [
        "About Us",
        "This app was developed to make learning fun and interactive!",
      ],
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/images/settingsmenu.png', fit: BoxFit.fill),

          // Glass effect overlay for whole screen
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.2), // semi-transparent overlay
              ),
            ),
          ),

          // Content on top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                ...buttons.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _buildButton(context, b[0], b[1]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
