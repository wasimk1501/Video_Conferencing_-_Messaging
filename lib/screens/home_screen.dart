import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_conferencing/common/colors.dart';
import 'package:video_conferencing/common/constant.dart';
import '../utils/drawer/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!.email;
  var userId = FirebaseAuth.instance.currentUser!.displayName;
  @override
  Widget build(BuildContext context) {
    print(" hello i am here $userId");
    // bool isDesktop(context) => MediaQuery.of(context).size.width >= 600;
    bool isMobile(BuildContext context) =>
        MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: NeomorphicColor.primaryColor,
      drawer: AppDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: TextColor.textColor, size: 30.0),
        centerTitle: true,
        backgroundColor: NeomorphicColor.primaryColor,
        elevation: 0,
        title: Hero(
            tag: "TitleAnimation",
            child: Text(
              "MeetingMinds",
              style: GoogleFonts.comfortaa(
                  fontWeight: FontWeight.bold, color: AppColor.themeColor),
              softWrap: true,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome",
                        style: GoogleFonts.comfortaa(
                            fontWeight: FontWeight.bold,
                            color: TextColor.textColor,
                            fontSize: AppFont.normalFontSize),
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Wasim Khan,",
                        style: GoogleFonts.comfortaa(
                            fontWeight: FontWeight.bold,
                            color: TextColor.textColor,
                            fontSize: AppFont.largeFontSize),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0, bottom: 20),
                    child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: NeomorphicColor.lightShadow,
                                  blurRadius: 20.0,
                                  offset: Offset(-10, -10),
                                  inset: true,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 8.0,
                                  offset: Offset(10, 10),
                                  inset: true,
                                ),
                              ],
                              color: NeomorphicColor.primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: AppColor.themeColor),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Create a new meeting",
                                style: GoogleFonts.comfortaa(
                                    color: AppColor.themeColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppFont.normalFontSize),
                              ),
                            ],
                          ),
                        ),
                        onTap: () =>
                            Navigator.pushNamed(context, "/createMeeting")),
                  ),
                  GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: NeomorphicColor.lightShadow,
                                  blurRadius: 20.0,
                                  offset: Offset(-10, -10),
                                  inset: true,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 8.0,
                                  offset: Offset(10, 10),
                                  inset: true,
                                ),
                              ],
                              color: NeomorphicColor.primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.connect_without_contact,
                                  color: AppColor.themeColor),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Join with the code",
                                style: GoogleFonts.comfortaa(
                                    color: AppColor.themeColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppFont.normalFontSize),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () =>
                          Navigator.pushNamed(context, "/joinMeeting")),
                ],
              ),
              if (isMobile(context))
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 300.0),
                      child: Center(
                        //   child: Hero(
                        // tag: "LottieAnimation",
                        child: Lottie.asset("assets/lottie/meeting.json",
                            width: 150),
                        // ),
                      ),
                    ),
                    Lottie.asset("assets/lottie/connection.json"),
                  ],
                ),
              const SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: NeomorphicColor.lightShadow,
              blurRadius: 20.0,
              offset: Offset(10, 10),
              inset: true,
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 8.0,
              offset: Offset(-10, -10),
              inset: true,
            ),
          ],
          color: NeomorphicColor.primaryColor,
        ),
        child: Center(
          child: Text(
            "2023 Video Conferencing App. All Rights Reserved.",
            style: GoogleFonts.comfortaa(
                color: Colors.grey,
                fontSize: AppFont.smallFontSize,
                textBaseline: TextBaseline.ideographic),
          ),
        ),
      ),
    );
  }
}
