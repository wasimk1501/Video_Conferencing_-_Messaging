import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_conferencing/common/colors.dart';
import 'package:video_conferencing/common/constant.dart';
import 'package:video_conferencing/utils/joining_options.dart';
import 'package:video_conferencing/utils/meet_textfield.dart';
import 'package:video_conferencing/utils/other_utils/other_utils.dart';
import 'package:video_conferencing/utils/utils_class.dart';

import 'meeting_screen.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({super.key});

  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

TextEditingController codeController = TextEditingController();
String roomId = "";

// bool isShareScreen = false;
bool isAudio = false;
bool isVideo = false;

class _CreateMeetingState extends State<CreateMeeting> {
  @override
  void initState() {
    roomId = generateRandomString(8);
    codeController = TextEditingController(text: roomId);
    super.initState();
  }

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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: TextColor.textColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  " Room Created",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comfortaa(
                      fontSize: AppFont.normalFontSize,
                      color: AppColor.themeColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Image.asset(
                    "assets/images/room_created_vector.png",
                    width: 300.0,
                  ),
                  MeetTextfield(
                    controller: codeController,
                    name: "Your Meeting code",
                    keyboardType: TextInputType.number,
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          bool isPermissionGranted =
                              await handlePermissionsForCall(context);
                          if (isPermissionGranted) {
                            setState(() {
                              isVideo = !isVideo;
                            });
                          } else {
                            Utils.showSnackbar(
                                "Failed, Microphone Permission Required for Video Call");
                          }
                        },
                        child: JoiningOption(
                            optionName: "Video",
                            optionIcon: isVideo
                                ? FontAwesomeIcons.video
                                : FontAwesomeIcons.videoSlash),
                      ),
                      GestureDetector(
                        onTap: () async {
                          bool isPermissionGranted =
                              await handlePermissionsForCall(context);
                          if (isPermissionGranted) {
                            setState(() {
                              isAudio = !isAudio;
                            });
                          } else {
                            Utils.showSnackbar(
                                "Failed, Microphone Permission Required for Video Call");
                          }
                        },
                        child: JoiningOption(
                            optionName: "Audio",
                            optionIcon: isAudio
                                ? FontAwesomeIcons.microphone
                                : FontAwesomeIcons.microphoneSlash),
                      ),
                      GestureDetector(
                        onTap: () {
                          shareToApps(roomId);
                        },
                        child: const JoiningOption(
                          optionName: "Share Invite",
                          optionIcon: Icons.share_rounded,
                        ),
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
                              "Start",
                              style: GoogleFonts.comfortaa(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () async {
                          // setState(() {
                          //   isPressed = !isPressed;
                          // });
                          bool isPermissionGranted =
                              await handlePermissionsForCall(context);
                          if (isPermissionGranted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MeetingScreen(
                                          channelName: roomId,
                                        )));
                          } else {
                            Utils.showSnackbar(
                                "Failed, Microphone Permission Required for Video Call");
                          }
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
