import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class CallPage extends StatelessWidget {
  final String callId;
  final User user;

  const CallPage({Key? key, required this.callId, required this.user}) : super(key: key);

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
        userID: '${user.userId}', // Replace with the user ID
        userName: '${user.firstName} ${user.lastName}', // Replace with the user name
        callID: callId,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}
