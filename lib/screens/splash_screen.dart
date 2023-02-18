import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Timer(
    //     const Duration(
    //       seconds: 2,
    //     ),
    //     () => Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => const HomeScreen())));
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "LottieAnimation",
              child: Lottie.asset("assets/lottie/meeting.json", width: 150),
            ),
            const Hero(
              tag: "TitleAnimation",
              child: Text(
                "MeetingMinds",
                style: TextStyle(fontSize: 25.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
