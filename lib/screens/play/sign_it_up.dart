import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your game screens
import 'sign_to_text_levels/sign_to_text.dart';
import 'text_to_sign_levels/text_to_sign.dart';
import 'sound_awareness_levels/sound_awareness.dart';

class SingItUp extends StatefulWidget {
  const SingItUp({super.key});

  @override
  State<SingItUp> createState() => _SingItUpState();
}

class _SingItUpState extends State<SingItUp> {
  int signToTextProgress = 0;
  int textToSignProgress = 0;
  int soundAwarenessProgress = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      int s2t = 0;
      if (prefs.getBool('easyDone') ?? false) s2t++;
      if (prefs.getBool('mediumDone') ?? false) s2t++;
      if (prefs.getBool('hardDone') ?? false) s2t++;
      signToTextProgress = s2t;

      int t2s = 0;
      if (prefs.getBool('tts_easyDone') ?? false) t2s++;
      if (prefs.getBool('tts_mediumDone') ?? false) t2s++;
      if (prefs.getBool('tts_hardDone') ?? false) t2s++;
      textToSignProgress = t2s;

      int sa = 0;
      if (prefs.getBool('sound_easyDone') ?? false) sa++;
      if (prefs.getBool('sound_mediumDone') ?? false) sa++;
      if (prefs.getBool('sound_hardDone') ?? false) sa++;
      soundAwarenessProgress = sa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          "assets/images/playmenu.png",
          fit: BoxFit.fill,
        ),

        // Glass effect overlay for whole screen
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.white.withOpacity(0.1),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text(
              'Sign It Up',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _buildGameButton(
                  context,
                  "Sign to Text",
                  Icons.pan_tool_alt_rounded,
                  [Colors.orange, Colors.deepOrange],
                  const SignToTextScreen(),
                  signToTextProgress,
                ),
                _buildGameButton(
                  context,
                  "Text to Sign",
                  Icons.text_fields_rounded,
                  [Colors.pink, Colors.purple],
                  const TextToSignScreen(),
                  textToSignProgress,
                ),
                _buildGameButton(
                  context,
                  "Sound Awareness",
                  Icons.volume_up_rounded,
                  [Colors.blue, Colors.blueAccent],
                  const SoundAwarenessScreen(),
                  soundAwarenessProgress,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameButton(
    BuildContext context,
    String label,
    IconData icon,
    List<Color> colors,
    Widget screen,
    int progress,
  ) {
    return _JollyButton(
      label: label,
      icon: icon,
      colors: colors,
      progress: progress,
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
        _loadProgress(); // refresh progress
      },
    );
  }
}

// ======================================================
// 🎉 JOLLY BUTTON WITH PROGRESS BAR
// ======================================================

class _JollyButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<Color> colors;
  final int progress; // 0-3
  final VoidCallback onTap;

  const _JollyButton({
    required this.label,
    required this.icon,
    required this.colors,
    required this.progress,
    required this.onTap,
  });

  @override
  State<_JollyButton> createState() => _JollyButtonState();
}

class _JollyButtonState extends State<_JollyButton>
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

  @override
  Widget build(BuildContext context) {
    double progressValue = widget.progress / 3; // 0.0 to 1.0

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1 - _controller.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          width: 150,
          height: 180,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
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
              Icon(
                widget.icon,
                size: 52,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.label}\n${widget.progress}/3",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
