import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_conferencing/common/colors.dart';
import 'package:video_conferencing/common/constant.dart';
import 'package:video_conferencing/utils/joining_options.dart';
import 'package:video_conferencing/utils/meet_textfield.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({super.key});

  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

TextEditingController codeController = TextEditingController();
TextEditingController nameController = TextEditingController();

// var uuid = Uuid();
bool isShareScreen = false;
bool isAudio = false;
bool isVideo = false;

class _CreateMeetingState extends State<CreateMeeting> {
  @override
  Widget build(BuildContext context) {
    double blur = 8.0;
    Offset distance = const Offset(10, 10);
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
                  "New meeting",
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
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isVideo = !isVideo;
                          });
                        },
                        child: JoiningOption(
                            optionName: "Video",
                            optionIcon: isVideo
                                ? Icons.videocam_outlined
                                : Icons.videocam_off_outlined),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isAudio = !isAudio;
                          });
                        },
                        child: JoiningOption(
                            optionName: "Audio",
                            optionIcon: isAudio
                                ? Icons.mic_outlined
                                : Icons.mic_off_outlined),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isShareScreen = !isShareScreen;
                          });
                        },
                        child: JoiningOption(
                            optionName: "Share Screen",
                            optionIcon: isShareScreen
                                ? Icons.present_to_all
                                : Icons.cancel_presentation_outlined),
                      ),
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
                              "Create",
                              style: GoogleFonts.comfortaa(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () {
                          // setState(() {
                          //   isPressed = !isPressed;
                          // });
                          Navigator.pushNamed(context, "/meeting");
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
