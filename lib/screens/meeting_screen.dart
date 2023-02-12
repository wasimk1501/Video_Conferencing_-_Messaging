import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

import 'package:video_conferencing/utils/settings.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({
    super.key,
  });

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  // Instantiate the client
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: "MeetingMinds",
    ),
  );
  //initialized the agora engine
  @override
  void initState() {
    // TODO: implement initStat_
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    //retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //initialize the client
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MeetingMinds"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AgoraVideoViewer(client: client),
          AgoraVideoButtons(client: client),
        ],
      ),
    );
  }
}
