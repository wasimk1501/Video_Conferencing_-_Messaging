import 'package:flutter/material.dart';

class JoinWithCode extends StatefulWidget {
  const JoinWithCode({super.key});

  @override
  State<JoinWithCode> createState() => _JoinWithCodeState();
}

TextEditingController nameController = TextEditingController();
TextEditingController codeController = TextEditingController();

class _JoinWithCodeState extends State<JoinWithCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 12.0, left: 5.0),
                child: Text(
                  "Your name",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 115, 112, 112)),
                ),
              ),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    alignLabelWithHint: false,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
                    hintText: "Enter your name"),
              ),
              const SizedBox(
                height: 25.0,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 12.0, left: 5.0),
                child: Text(
                  "Meeting code",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 115, 112, 112)),
                ),
              ),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    alignLabelWithHint: false,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
                    hintText: "eg. 123456"),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: Color(0xff1590D4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.videocam,
                          size: 40.0,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Video",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 78, 77, 77),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                            color: Color(0xff1590D4),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Icon(
                          Icons.mic_rounded,
                          size: 40.0,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Audio",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 78, 77, 77),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                            color: const Color(0xff1590D4),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Icon(
                          Icons.present_to_all,
                          size: 40.0,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Share Screen",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 78, 77, 77),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
