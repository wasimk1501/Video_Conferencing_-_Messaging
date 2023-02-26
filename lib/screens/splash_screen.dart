import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_conferencing/common/colors.dart';
import 'package:video_conferencing/common/constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/splashBackground.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hero(
                  //   tag: "LottieAnimation",
                  //   child:
                  //       Lottie.asset("assets/lottie/meeting.json", width: 150),
                  // ),
                  Hero(
                    tag: "TitleAnimation",
                    child: Text(
                      "MeetingMinds",
                      style: GoogleFonts.comfortaa(
                          fontSize: AppFont.extraLargeFontSize,
                          fontWeight: FontWeight.w800,
                          color: AppColor.themeColor),
                    ),
                  ),
                  const SizedBox(
                    height: 200.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
