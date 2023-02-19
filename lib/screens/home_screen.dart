import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_conferencing/utils/login_widget.dart';
import 'package:video_conferencing/utils/signup_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!.email;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    bool isDesktop(context) => MediaQuery.of(context).size.width >= 600;
    bool isMobile(BuildContext context) =>
        MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Hero(
            tag: "TitleAnimation",
            child: Text(
              "MeetingMinds",
              softWrap: true,
            )),
        actions: [
          ElevatedButton(
              onPressed: () {
                rEmailController.clear();
                rPasswordController.clear();
                rConfirmPasswordController.clear();
                lEmailController.clear();
                lPasswordController.clear();
                FirebaseAuth.instance.signOut();
              },
              child: const Text("Logout")),
          // IconButton(
          //     onPressed: () {
          //       // Navigator.pushReplacementNamed(context, "/login");
          //     },
          //     icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0, bottom: 20),
                    child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Create a new meeting",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
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
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.connect_without_contact,
                                  color: Colors.white),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Join with the code",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
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
        height: 80,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 247, 247, 247),
            borderRadius: BorderRadius.circular(20)),
        child: const Center(
          child: Text(
            "2023 Video Call App. All Rights Reserved.",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                overflow: TextOverflow.visible),
          ),
        ),
      ),
    );
  }
}
