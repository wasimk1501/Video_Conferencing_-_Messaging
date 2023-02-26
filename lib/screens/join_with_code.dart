import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_conferencing/common/colors.dart';
import 'package:video_conferencing/common/constant.dart';
import 'package:video_conferencing/utils/joining_options.dart';
import 'package:video_conferencing/utils/meet_textfield.dart';

class JoinWithCode extends StatefulWidget {
  const JoinWithCode({super.key});

  @override
  State<JoinWithCode> createState() => _JoinWithCodeState();
}

TextEditingController codeController = TextEditingController();
TextEditingController nameController = TextEditingController();

// var uuid = Uuid();
bool isPressed = false;

class _JoinWithCodeState extends State<JoinWithCode> {
  @override
  Widget build(BuildContext context) {
    double blur = isPressed ? 8.0 : 20.0;
    Offset distance = isPressed ? const Offset(10, 10) : const Offset(25, 25);
    return Scaffold(
      backgroundColor: NeomorphicColor.primaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: TextColor.textColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "Enter the code",
                  style: GoogleFonts.comfortaa(
                      fontSize: AppFont.normalFontSize,
                      fontWeight: FontWeight.bold,
                      color: TextColor.textColor),
                ),
              ],
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  MeetTextfield(
                    controller: nameController,
                    name: "Your name",
                    hintText: "eg. Wasim Khan",
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  MeetTextfield(
                    controller: codeController,
                    name: "Meeting code",
                    hintText: "eg. 123456",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      JoiningOption(
                          optionName: "Video",
                          optionIcon: Icons.video_camera_front),
                      JoiningOption(optionName: "Audio", optionIcon: Icons.mic),
                      JoiningOption(
                          optionName: "Share Screen",
                          optionIcon: Icons.present_to_all),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0, bottom: 20),
                    child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: NeomorphicColor.lightShadow,
                                  blurRadius: blur,
                                  offset: -distance,
                                  inset: true,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: blur,
                                  offset: distance,
                                  inset: true,
                                ),
                              ],
                              color: NeomorphicColor.primaryColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20.0))),
                          child: Center(
                            child: Text(
                              "Join",
                              style: GoogleFonts.comfortaa(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isPressed = !isPressed;
                          });
                          // Navigator.pushNamed(context, "/meeting");
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
