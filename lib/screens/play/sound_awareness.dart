import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// SoundInfo model
class SoundInfo {
  final String title;
  final String meaning;
  final String description;
  final String imagePath;
  final String soundPath;

  const SoundInfo({
    required this.title,
    required this.meaning,
    required this.description,
    required this.imagePath,
    required this.soundPath,
  });
}

// List of sound examples
final List<SoundInfo> sounds = [
  SoundInfo(
    title: 'Ambulance Siren',
    meaning: 'Emergency vehicle approaching',
    description:
        'A loud siren sound that indicates an ambulance is near. Step aside for emergency response.',
    imagePath: 'assets/images/ambulance.png',
    soundPath: 'sounds/ambulance.mp3',
  ),
  SoundInfo(
    title: 'Fire Alarm',
    meaning: 'Fire emergency',
    description:
        'A repetitive, loud beep that warns of fire or smoke. Evacuate immediately.',
    imagePath: 'assets/images/alarm.png',
    soundPath: 'sounds/alarm.mp3',
  ),
  SoundInfo(
    title: 'Smoke Detector',
    meaning: 'Smoke or low battery',
    description:
        'A single chirp or steady beep that may mean smoke detected or battery is low.',
    imagePath: 'assets/images/smoke_detector.png',
    soundPath: 'sounds/smoke_detector.mp3',
  ),
  SoundInfo(
    title: 'Doorbell',
    meaning: 'Someone is at the door',
    description:
        'A chime sound indicating a visitor. Often paired with lights for hearing-impaired.',
    imagePath: 'assets/images/doorbell.png',
    soundPath: 'sounds/doorbell.mp3',
  ),
  SoundInfo(
    title: 'Phone Ringing',
    meaning: 'Incoming call',
    description:
        'Repeating tones that indicate someone is calling. Can be paired with vibration.',
    imagePath: 'assets/images/telephone_call.png',
    soundPath: 'sounds/telephone_ring.mp3',
  ),
  SoundInfo(
    title: 'Car Horn',
    meaning: 'Vehicle warning',
    description:
        'Short, loud honk to alert you of danger or get attention in traffic.',
    imagePath: 'assets/images/horn.png',
    soundPath: 'sounds/horn.mp3',
  ),
  SoundInfo(
    title: 'Baby Crying',
    meaning: 'Infant needs care',
    description:
        'A loud cry used by babies to show hunger, discomfort, or pain.',
    imagePath: 'assets/images/baby.png',
    soundPath: 'sounds/baby.mp3',
  ),
  SoundInfo(
    title: 'Alarm Clock',
    meaning: 'Wake-up or alert',
    description:
        'Loud ringing sound used to wake someone up or remind them of a task.',
    imagePath: 'assets/images/alarm_clock.png',
    soundPath: 'sounds/alarm_clock.mp3',
  ),
];

// Main widget
class SoundAwareness extends StatelessWidget {
  const SoundAwareness({super.key});

  Widget _buildBox(BuildContext context, SoundInfo info) {
    return GestureDetector(
      onTap: () async {
        final player = AudioPlayer();

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(info.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Click the image to play the sound.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () async {
                    await player.play(AssetSource(info.soundPath));
                  },
                  child: Image.asset(
                    info.imagePath,
                    width: 100,
                    height: 100,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Meaning: ${info.meaning}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text(info.description),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await player.stop(); // stop sound when closing
                  Navigator.pop(ctx);
                },
                child: const Text("Close"),
              ),
            ],
          ),
        ).then((_) async {
          // This handles cases where dialog is closed by tapping outside
          await player.stop();
          await player.dispose(); // optional: releases resources
        });
      },
      child: Container(
        width: 100,
        height: 120,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(info.imagePath, width: 40, height: 40),
            const SizedBox(height: 5),
            Text(
              info.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
          Image.asset("assets/images/playmenu.png", fit: BoxFit.fill),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBox(context, sounds[0]),
                    _buildBox(context, sounds[1]),
                    _buildBox(context, sounds[2]),
                    _buildBox(context, sounds[3]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBox(context, sounds[4]),
                    _buildBox(context, sounds[5]),
                    _buildBox(context, sounds[6]),
                    _buildBox(context, sounds[7]),
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
