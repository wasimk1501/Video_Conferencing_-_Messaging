import "dart:developer";

import "package:agora_rtc_engine/agora_rtc_engine.dart";
import "package:convex_bottom_bar/convex_bottom_bar.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:permission_handler/permission_handler.dart";
import "package:signal_strength_indicator/signal_strength_indicator.dart";
import "package:video_conferencing/screens/home_screen.dart";

import "../controller/agora_controller.dart";
import "../utils/settings.dart";

class CallScreen extends StatefulWidget {
  final String channelName;
  // final ClientRoleType role;
  // final bool userJoined;
  const CallScreen({
    super.key,
    required this.channelName,
    // required this.role,
    // required this.userJoined
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

int uid = 0; // uid of the local user
bool muted = false;
bool muteVideo = false;
bool isSomeOneJoinedCall = false;
int? _remoteUid; // uid of the remote user
bool _isJoined = false; // Indicates if the local user has joined the channel
late RtcEngine agoraEngine; // Agora engine instance
// Check for the network quality
int networkQuality = 3;
Color networkQualityBarColor = Colors.green;
// get instance of agora controller
final AgoraController agoraController = Get.put(AgoraController());
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

showMessage(String message) {
  scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Text(message),
  ));
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();

    // Set up an instance of Agora engine
    setupVideoSDKEngine();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Welcome to my app!"),
            content: Text("Thank you for installing my app."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  join();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          if (agoraController.meetingTimer != null) {
            // if (!agoraController.meetingTimer?.isActive) {
            agoraController.startMeetingTimer();
            // }
          } else {
            agoraController.startMeetingTimer();
          }

          setState(() {
            isSomeOneJoinedCall = true;
          });
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage(
              "Remote user uid:$remoteUid left the channel because of $reason");
          setState(() {
            _remoteUid = null;
          });
        },
        onNetworkQuality:
            (connection, remoteUid, txQuality, QualityType rxQuality) {
          setState(() {
            print("Quality Type :${txQuality.index.toString()}");
            networkQuality = getNetworkQuality(txQuality.index);
            networkQualityBarColor = getNetworkQualityBarColor(txQuality.index);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool confirm = await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text("Confirm"),
                  content: Text("Are you sure want to exit?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Confirm"),
                    ),
                  ],
                ));
        return confirm;
      },
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Get started with Video Calling'),
          //   // actions: [
          //   //   Expanded(
          //   //     child: ElevatedButton(
          //   //       onPressed: _isJoined ? null : () => {join()},
          //   //       child: const Text("Join"),
          //   //     ),
          //   //   ),
          //   //   const SizedBox(width: 10),
          //   //   Expanded(
          //   //     child: ElevatedButton(
          //   //       onPressed: _isJoined ? () => {leave()} : null,
          //   //       child: const Text("Leave"),
          //   //     ),
          //   //   ),
          //   // ],
          // ),
          body: Stack(
            children: [
              _localPreview(),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  margin: EdgeInsets.only(right: 15.0, top: 40.0),
                  // alignment: Alignment.center,
                  height: 150,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _remoteVideo()),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    child: const Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SignalStrengthIndicator.bars(
                        value: networkQuality,
                        size: 18,
                        barCount: 4,
                        spacing: 0.3,
                        maxValue: 4,
                        activeColor: networkQualityBarColor,
                        inactiveColor: Colors.white,
                        radius: Radius.circular(8),
                        minValue: 0,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Obx(() {
                        return Text(
                          agoraController.meetingDurationTxt.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 2.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ConvexAppBar(
            style: TabStyle.fixedCircle,
            backgroundColor: Colors.blue,
            color: Colors.white,
            items: [
              TabItem(
                icon: muted ? Icons.mic_off_outlined : Icons.mic_outlined,
              ),
              const TabItem(
                icon: Icons.call_end_rounded,
              ),
              TabItem(
                icon:
                    muteVideo ? Icons.camera_rear_rounded : Icons.camera_front,
              ),
            ],
            initialActiveIndex: 2, //optional, default as 0
            onTap: (int i) {
              switch (i) {
                case 0:
                  _onToggleMute();
                  break;
                case 1:
                  _onCallEnd(context);
                  break;
                case 2:
                  _onSwitchCamera();
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channel),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }

// Display local video preview
  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

  void join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: tempToken,
      channelId: channel,
      options: options,
      uid: uid,
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

// Release the resources when you leave
  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    log("\n============ ON DISPOSE ===============\n");

    if (agoraController.meetingTimer != null) {
      agoraController.meetingTimer!.cancel();
    }

    //destroy agora sdk
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  void _onCallEnd(BuildContext context) {
    leave();
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    agoraEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() async {
    setState(() {
      muteVideo = !muteVideo;
    });
    await agoraEngine.switchCamera();
  }

  int getNetworkQuality(int txQuality) {
    switch (txQuality) {
      case 0:
        return 2;

      case 1:
        return 4;

      case 2:
        return 3;

      case 3:
        return 2;

      case 4:
        return 1;

      case 4:
        return 0;
    }
    return 0;
  }

  Color getNetworkQualityBarColor(int txQuality) {
    switch (txQuality) {
      case 0:
        return Colors.green;

      case 1:
        return Colors.green;

      case 2:
        return Colors.yellow;

      case 3:
        return Colors.redAccent;

      case 4:
        return Colors.red;

      case 4:
        return Colors.red;
    }
    return Colors.yellow;
  }
}
