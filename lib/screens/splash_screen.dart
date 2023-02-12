import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_conferencing/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(
          seconds: 2,
        ),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen())));
    return Scaffold(
        body: Center(
            child: Text(
      "Video Conferencing App",
      style: TextStyle(fontSize: 25.0),
    )));
  }
}
