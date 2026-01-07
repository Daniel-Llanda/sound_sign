import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // ✅ Add this dependency

class SingAlongAdventure extends StatelessWidget {
  const SingAlongAdventure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> alphabets =
        List.generate(26, (index) => String.fromCharCode(97 + index)); // a-z

    return Stack(
      fit: StackFit.expand,
      children: [
        // 🌈 Background Image
        Image.asset("assets/images/playmenu.png", fit: BoxFit.fill),

        // 💨 Glass Effect Overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.white.withOpacity(0.1), // semi-transparent glass
          ),
        ),

        // 🏗 Scaffold on top for AppBar & Grid
        Scaffold(
          backgroundColor: Colors.transparent, // Make Scaffold transparent
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text(
              'Sign Language',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(129, 0, 0, 0),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              itemCount: alphabets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final letter = alphabets[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlphabetScreen(letter: letter),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/sign_tutorial/asl_img/$letter.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ⚡ Alphabet Screen with Video Playback
class AlphabetScreen extends StatefulWidget {
  final String letter;

  const AlphabetScreen({Key? key, required this.letter}) : super(key: key);

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/images/sign_tutorial/asl_vid/${widget.letter.toUpperCase()}.mp4',
    )
      ..initialize().then((_) {
        setState(() {}); // Refresh to show video
        _controller.play();
        _controller.setLooping(true); // optional: loop video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.letter.toUpperCase()),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
