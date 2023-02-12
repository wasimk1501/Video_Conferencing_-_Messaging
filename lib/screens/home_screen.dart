import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_conferencing/screens/create_meeting.dart';
import 'package:video_conferencing/screens/join_with_code.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Hero(tag: "TitleAnimation", child: Text("MeetingMinds"))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateMeeting()),
                  ),
                ),
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JoinWithCode()),
                ),
              ),
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
