import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoView extends StatefulWidget {
  final RTCVideoRenderer video;
  final double height;
  final bool isMirrored;

  const VideoView(this.video, {Key? key,this.height = 210,this.isMirrored = false} ) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Container(
        margin: const EdgeInsets.fromLTRB(1.0, 1.0, 3.0, 1.0),
        decoration: const BoxDecoration(color: Colors.black),
        child: RTCVideoView(
          widget.video,
          mirror: widget.isMirrored,
        ),
      ),
    );
  }
}
