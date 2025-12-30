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
    description: 'A loud siren sound that indicates an ambulance is near. Step aside for emergency response.',
    imagePath: 'assets/images/ambulance.png',
    soundPath: 'sounds/ambulance.mp3',
  ),
  SoundInfo(
    title: 'Fire Alarm',
    meaning: 'Fire emergency',
    description: 'A repetitive, loud beep that warns of fire or smoke. Evacuate immediately.',
    imagePath: 'assets/images/alarm.png',
    soundPath: 'sounds/alarm.mp3',
  ),
  SoundInfo(
    title: 'Smoke Detector',
    meaning: 'Smoke or low battery',
    description: 'A single chirp or steady beep that may mean smoke detected or battery is low.',
    imagePath: 'assets/images/smoke_detector.png',
    soundPath: 'sounds/smoke_detector.mp3',
  ),
  SoundInfo(
    title: 'Doorbell',
    meaning: 'Someone is at the door',
    description: 'A chime sound indicating a visitor. Often paired with lights for hearing-impaired.',
    imagePath: 'assets/images/doorbell.png',
    soundPath: 'sounds/doorbell.mp3',
  ),
  SoundInfo(
    title: 'Phone Ringing',
    meaning: 'Incoming call',
    description: 'Repeating tones that indicate someone is calling. Can be paired with vibration.',
    imagePath: 'assets/images/telephone_call.png',
    soundPath: 'sounds/telephone_ring.mp3',
  ),
  SoundInfo(
    title: 'Car Horn',
    meaning: 'Vehicle warning',
    description: 'Short, loud honk to alert you of danger or get attention in traffic.',
    imagePath: 'assets/images/horn.png',
    soundPath: 'sounds/horn.mp3',
  ),
  SoundInfo(
    title: 'Baby Crying',
    meaning: 'Infant needs care',
    description: 'A loud cry used by babies to show hunger, discomfort, or pain.',
    imagePath: 'assets/images/baby.png',
    soundPath: 'sounds/baby.mp3',
  ),
  SoundInfo(
    title: 'Alarm Clock',
    meaning: 'Wake-up or alert',
    description: 'Loud ringing sound used to wake someone up or remind them of a task.',
    imagePath: 'assets/images/alarm_clock.png',
    soundPath: 'sounds/alarm_clock.mp3',
  ),
];

class SoundAwareness extends StatelessWidget {
  const SoundAwareness({super.key});

  Widget _buildJollyButton(BuildContext context, SoundInfo info, List<Color> colors) {
    return _JollySoundButton(info: info, colors: colors);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        Image.asset("assets/images/playmenu.png", fit: BoxFit.fill),

        // Glass effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(color: Colors.white.withOpacity(0.1)),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Sound Awareness', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // First row (first 4 buttons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildJollyButton(context, sounds[0], [Colors.orange, Colors.deepOrange]),
                    _buildJollyButton(context, sounds[1], [Colors.pink, Colors.purple]),
                    _buildJollyButton(context, sounds[2], [Colors.blue, Colors.lightBlueAccent]),
                    _buildJollyButton(context, sounds[3], [Colors.green, Colors.lightGreen]),
                  ],
                ),
                const SizedBox(height: 20),
                // Second row (next 4 buttons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildJollyButton(context, sounds[4], [Colors.deepPurple, Colors.purpleAccent]),
                    _buildJollyButton(context, sounds[5], [Colors.red, Colors.orangeAccent]),
                    _buildJollyButton(context, sounds[6], [Colors.teal, Colors.cyan]),
                    _buildJollyButton(context, sounds[7], [Colors.indigo, Colors.blueAccent]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================================================
// 🎉 Jolly Sound Button
// ================================================
class _JollySoundButton extends StatefulWidget {
  final SoundInfo info;
  final List<Color> colors;

  const _JollySoundButton({required this.info, required this.colors, super.key});

  @override
  State<_JollySoundButton> createState() => _JollySoundButtonState();
}

class _JollySoundButtonState extends State<_JollySoundButton>
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

  Future<void> _playSound(BuildContext context) async {
    final player = AudioPlayer();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.info.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Click the image to play the sound.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                await player.play(AssetSource(widget.info.soundPath));
              },
              child: Image.asset(widget.info.imagePath, width: 100, height: 100),
            ),
            const SizedBox(height: 10),
            Text("Meaning: ${widget.info.meaning}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(widget.info.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await player.stop();
              Navigator.pop(ctx);
            },
            child: const Text("Close"),
          ),
        ],
      ),
    ).then((_) async {
      await player.stop();
      await player.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        _playSound(context);
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1 - _controller.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          width: 120,
          height: 140,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
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
              Image.asset(widget.info.imagePath, width: 50, height: 50),
              const SizedBox(height: 8),
              Text(
                widget.info.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
