import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID, required this.userID, required this.userName}) : super(key: key);
  final String callID;
  final String userID;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final config = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
      ..onOnlySelfInRoom = (context) {
        Navigator.of(context).pop();
      };

    return ZegoUIKitPrebuiltCall(
      appID: 909621478, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: "111b58d37fa7d7903d411169d42a0d92671455cde73e341869b65f650174c669", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userID, // Replace with your user ID
      userName: userName, // Replace with your user name
      callID: callID,
      config: config,
    );
  }
}
