import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'edit_account.dart';
import 'package:sound_sign/screens/play/play.dart';
import 'package:sound_sign/screens/settings/settings.dart';
import 'package:sound_sign/screens/tutorials/tutorial.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  final int id;
  final String name;
  final String username;
  final String? gender; // nullable

  const HomeScreen({
    Key? key,
    required this.id,
    required this.name,
    required this.username,
    this.gender,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWoman = true;

  void toggleAvatar() {
    setState(() {
      isWoman = !isWoman;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bghome.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // ✅ All content stacked on top
          Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PlayScreen()),
                          );
                        },
                        child: Text(
                          'Play',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          minimumSize: Size(200, 50),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SettingsScreen()),
                          );
                        },
                        child: Text(
                          'Settings',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          minimumSize: Size(200, 50),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TutorialsScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Tutorials',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          minimumSize: Size(200, 50), // Width, Height
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Logout button
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text('Logout', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ),

              // Avatar & Edit Account
              Positioned(
                bottom: 20,
                left: 20,
                child: ClipRRect(
                  // Required for BackdropFilter to clip the blur
                  borderRadius: BorderRadius.circular(
                    20,
                  ), // Optional: rounded corners
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.2,
                        ), // Semi-transparent white
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: toggleAvatar,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                (widget.gender?.toLowerCase() == 'male')
                                    ? 'assets/images/man.png'
                                    : (widget.gender?.toLowerCase() == 'female'
                                        ? 'assets/images/woman.png'
                                        : 'assets/images/default.png'),
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${widget.name}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EditAccountScreen(
                                        id: widget.id,
                                        name: widget.name,
                                        username: widget.username,
                                        gender: widget.gender,
                                      ),
                                ),
                              );
                            },
                            child: Text(
                              'Edit Account',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
