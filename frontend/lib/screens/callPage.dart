import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:flutter/material.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    var yourAppSign =
        '9f9b047e872ca8e807b41744bf12b44780184c663a18601f369ed71fca2ee98f';
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Page'),
      ),
      body: ZegoUIKitPrebuiltCall(
        appID: 45384776, // Replace with your appID from ZEGOCLOUD Admin Console
        appSign:
            yourAppSign, // Replace with your appSign from ZEGOCLOUD Admin Console
        userID: '91', // Replace with the user ID
        userName: ' brother', // Replace with the user name
        callID: callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}
