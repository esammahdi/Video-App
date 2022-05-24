import 'package:flutter/material.dart';
import '../../constants/styles.dart';
import 'meeting_action_button.dart';

// Meeting ActionBar
class MeetingActionBar extends StatelessWidget {
  // control states
  final bool isMicEnabled,
      isWebcamEnabled;

  // callback functions
  final void Function() onCallEndButtonPressed,
      onMicButtonPressed,
      onWebcamButtonPressed;

  final double iconSize;

  const MeetingActionBar({
    Key? key,
    required this.isMicEnabled,
    required this.isWebcamEnabled,
    required this.onCallEndButtonPressed,
    required this.onMicButtonPressed,
    required this.onWebcamButtonPressed,
    this.iconSize = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // color: Theme.of(context).backgroundColor,
      child: SizedBox(
        width : size.width * 0.85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Call End Control
            GestureDetector(
              onTap: onCallEndButtonPressed,
              child: SizedBox(
                width: size.width * 0.2,
                child: MeetingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: onCallEndButtonPressed,
                  icon: Icons.call_end,
                  iconSize: iconSize,
                ),
              ),
            ),

            // Mic Control
            GestureDetector(
              onTap: onMicButtonPressed,
              child: SizedBox(
                                width: size.width * 0.2,

                child: MeetingActionButton(
                  onPressed: onMicButtonPressed,
                  backgroundColor:
                      isMicEnabled ? hoverColor : secondaryColor.withOpacity(0.8),
                  icon: isMicEnabled ? Icons.mic : Icons.mic_off,
                  iconSize: iconSize,
                ),
              ),
            ),

            // Webcam Control
            GestureDetector(
              onTap: onWebcamButtonPressed,
              child: SizedBox(
                                width: size.width * 0.2,

                child: MeetingActionButton(
                  onPressed: onWebcamButtonPressed,
                  backgroundColor: isWebcamEnabled
                      ? hoverColor
                      : secondaryColor.withOpacity(0.8),
                  icon: isWebcamEnabled ? Icons.videocam : Icons.videocam_off,
                  iconSize: iconSize,
                ),
              ),
            ),

            // Webcam Switch Control
            // if(Platform.isAndroid)

          ],
        ),
      ),
    );
  }
}
