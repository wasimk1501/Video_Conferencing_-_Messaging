import 'dart:async';
import 'dart:developer';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';
import 'package:video_conferencing/common/colors.dart';
import 'package:video_conferencing/controller/agora_controller.dart';
import 'package:video_conferencing/screens/home_screen.dart';
import 'package:video_conferencing/utils/settings.dart';

class MeetingScreen extends StatefulWidget {
  final String channelName;
  final bool isCreator;
  final bool isAudio;
  final bool isVideo;
  final bool? isCameraFront;
  const MeetingScreen(
      {super.key,
      required this.channelName,
      required this.isAudio,
      required this.isVideo,
      this.isCameraFront,
      required this.isCreator});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  static final _users = <int>[];
  final _infoStrings = <String>[];

  String token = tempToken;
  // int uid = 0; // uid of the local user
  bool muted = false;
  bool muteVideo = false;
  int? _remoteUid;
  bool isFrontCamera = false;
  // uid of the remote user
  bool isSomeOneJoinedCall =
      false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine;
  // get instance of agora controller
  final AgoraController agoraController =
      Get.put(AgoraController()); // Agora engine instance
// Check for the network quality
  int networkQuality = 3;
  Color networkQualityBarColor = Colors.green;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  //instance for the setState
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // Release the resources when you leave
  @override
  void dispose() async {
    log("\n============ ON DISPOSE ===============\n");
    super.dispose();

    if (agoraController.meetingTimer != null) {
      agoraController.meetingTimer!.cancel();
    }

    //clear user
    _users.clear();

    //destroy agora sdk
    await agoraEngine.leaveChannel();
    agoraEngine.release();
  }

  @override
  void initState() {
    join();
    log(appId);
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
    super.initState();
  }
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     scaffoldMessengerKey: scaffoldMessengerKey,
  //     home: Scaffold(
  //         appBar: AppBar(
  //           title: const Text('Video Calling'),
  //           centerTitle: true,
  //           // actions: [
  //           //   Row(
  //           //     children: <Widget>[
  //           //       ElevatedButton(
  //           //         onPressed: isSomeOneJoinedCall ? null : () => {join()},
  //           //         child: const Text("Join"),
  //           //       ),
  //           //       const SizedBox(width: 10),
  //           //       ElevatedButton(
  //           //         onPressed: isSomeOneJoinedCall ? () => {leave()} : null,
  //           //         child: const Text("Leave"),
  //           //       ),
  //           //     ],
  //           //   ),
  //           // ],
  //         ),
  //         body: Stack(
  //           children: [
  //             // Container for the local video
  //             Center(child: _remoteVideo()),
  //             Container(
  //               height: 150,
  //               width: 130,
  //               decoration: BoxDecoration(border: Border.all()),
  //               child: Center(child: _localPreview()),
  //             ),
  //             const SizedBox(height: 10),
  //             _toolbar(),
  //           ],
  //         )),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // if (!widget.isCreator) {
    //   log(widget.isCreator.toString());
    //   join();
    // }
    return WillPopScope(
      onWillPop: () async {
        log(_users.toString());
        // Show a confirmation dialog
        bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm'),
              content: Text('Are you sure you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );

        // Return the result of the confirmation dialog
        return confirm ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Video Call"),
          actions: [
            ElevatedButton(
              child: Text("Join"),
              onPressed: () {
                join();
              },
            )
          ],
        ),
        body: buildNormalVideoUI(),
        bottomNavigationBar: GetBuilder<AgoraController>(builder: (_) {
          return ConvexAppBar(
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
                icon: muteVideo
                    ? Icons.videocam_off_outlined
                    : Icons.videocam_outlined,
              ),
            ],
            initialActiveIndex: 2, //optional, default as 0
            onTap: (int i) {
              switch (i) {
                case 0:
                  _onToggleMute();
                  break;
                case 1:
                  onCallEnd(context);
                  break;
                case 2:
                  _onSwitchCamera();
                  break;
              }
            },
          );
        }),
      ),
    );
  }

  // Display local video preview
  Widget _localPreview() {
    if (isSomeOneJoinedCall) {
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

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      String msg = '';
      if (isSomeOneJoinedCall) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }

  List<Widget> _getRenderViews() {
    final List<AgoraVideoView> list = [
      AgoraVideoView(
          controller: VideoViewController(
              rtcEngine: agoraEngine, canvas: VideoCanvas(uid: 0)))
    ];
    _users.forEach((int uid) => list.add(AgoraVideoView(
        controller: VideoViewController(
            rtcEngine: agoraEngine, canvas: VideoCanvas(uid: uid)))));

    log(list.toString());
    return list;
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget buildJoinUserUI() {
    final views = _getRenderViews();

    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      _expandedVideoRow([views[1]]),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 8,
                            color: Colors.white38,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 40, 10, 15),
                        width: 110,
                        height: 140,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _expandedVideoRow([views[0]]),
                          ],
                        )))
              ],
            ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container(
      color: Colors.red,
      height: 100,
    );
  }

  Widget buildNormalVideoUI() {
    return Container(
      height: Get.height,
      child: Stack(
        children: <Widget>[
          buildJoinUserUI(),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 10, top: 30),
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
          Align(
            alignment: Alignment.bottomRight,
            child: GetBuilder<AgoraController>(
              builder: (_) {
                return Container(
                  margin: const EdgeInsets.only(right: 10, bottom: 4),
                  child: RawMaterialButton(
                    onPressed: _onSwitchCamera,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    fillColor: Colors.white38,
                    child: Icon(
                      isFrontCamera ? Icons.camera_rear : Icons.camera_front,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onCallEnd(BuildContext context) async {
    agoraController.meetingTimer?.cancel();
    if (isSomeOneJoinedCall) {
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "No one has not joined this call yet,\nDo You want to close this room?"),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
            ),
            ElevatedButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> setupVideoSDKEngine() async {
    if (appId.isEmpty) {
      Get.snackbar("", "Agora APP_ID Is Not Valid");
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await agoraEngine.enableWebSdkInteroperability(true);
    // await agoraEngine.setParameters(
    //     '''{\"che.video.lowBitRateStreamParameter\":{\"width\":640,\"height\":360,\"frameRate\":30,\"bitRate\":800}}''');
    join();
  }

  Future<void> _initAgoraRtcEngine() async {
    // //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: appId));
    await agoraEngine.enableVideo();
    await agoraEngine.startPreview();
  }

  void _addAgoraEventHandlers() {
    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            final info =
                'Local user uid:${connection.localUid} joined the channel"';
            _infoStrings.add(info);
          });
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            isSomeOneJoinedCall = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          log("======================================");
          log("             User Joined              ");
          log("======================================");
          if (agoraController.meetingTimer != null) {
            // if (!agoraController.meetingTimer?.isActive) {
            agoraController.startMeetingTimer();
            // }
          } else {
            agoraController.startMeetingTimer();
          }

          setState(() {
            isSomeOneJoinedCall = true;

            final info = 'userJoined: $remoteUid';
            _infoStrings.add(info);
            _users.add(remoteUid);
          });
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          setState(() {
            _infoStrings
                .add('User uid: ${connection.localUid} leaved the channel');
            _users.clear();
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            final info = 'userOffline: $remoteUid';
            _infoStrings.add(info);
            _users.remove(remoteUid);
          });
          showMessage("Remote user uid:$remoteUid left the channel");
          // setState(() {
          //   _remoteUid = null;
          // });
        },
        onNetworkQuality:
            (connection, remoteUid, txQuality, QualityType rxQuality) {
          setState(() {
            print("Quality Type :${txQuality.index.toString()}");
            networkQuality = getNetworkQuality(txQuality.index);
            networkQualityBarColor = getNetworkQualityBarColor(txQuality.index);
          });
        },
        onFirstRemoteVideoFrame:
            (connection, remoteUid, width, height, elapsed) {
          setState(() {
            final info = 'firstRemoteVideo: $remoteUid ${width}x $height';
            _infoStrings.add(info);
          });
        },
        onUserMuteAudio: (connection, remoteUid, muted) {
          setState(() {});
          showMessage("Local user uid:${connection.localUid} is muted.");
        },
      ),
    );
  }

  void join() async {
    // await agoraEngine.startPreview();
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    await agoraEngine.joinChannel(
      token: token,
      channelId: widget.channelName,
      options: options,
      uid: 0,
    );
  }

  void leave() {
    setState(() {
      isSomeOneJoinedCall = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
          )
        ],
      ),
    );
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

  void _onSwitchCamera() {
    agoraEngine.switchCamera();
  }

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void addLogToList(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
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
