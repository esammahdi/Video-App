import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

import '../widgets/meeting_action_bar.dart';
import '../../services/rtc_service.dart';
import '../home/home.dart';
import '../widgets/video_view.dart';

class Room extends StatefulWidget {
  final MediaStream? stream;
  const Room(this.stream, {Key? key}) : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  bool isMicEnabled = true;
  bool isWebCamEnabled = true;
  late RTCPeerConnection peerConnection;
  final RTCVideoRenderer _localVideo = RTCVideoRenderer();
  final RTCVideoRenderer _remoteVideo = RTCVideoRenderer();

  
  @override
  didChangeDependencies() {
    peerConnection =
        Provider.of<RTCService>(context, listen: false).peerConnection;
    init();
    super.didChangeDependencies();
  }

  Future<void> init() async {
    await _localVideo.initialize();
    await _remoteVideo.initialize();
    final remoteStreams = peerConnection.getRemoteStreams();

    _localVideo.srcObject = widget.stream;

    if (peerConnection.getRemoteStreams().isEmpty) {
      peerConnection.onAddStream = (stream) {
        stream
            .getTracks()
            .forEach((track) => peerConnection.addTrack(track, stream));
        _remoteVideo.srcObject = stream;

        setState(() {});
      };
    } else {
      _remoteVideo.srcObject = remoteStreams[0];
    }
  }

  @override
  void deactivate() async {
    await _disposeLocal();
    await _disposeRemote();
    super.deactivate();
  }

  @override
  void dispose() async {
    await _disposeLocal();
    await _disposeRemote();
    await peerConnection.close();
    super.dispose();
  }

  Future<void> _disposeLocal() async {
    var _stream = _localVideo.srcObject;

    if (_stream != null) {
      _stream.getTracks().forEach(
        (element) async {
          await element.stop();
        },
      );

      await _stream.dispose();
      _stream = null;
    }

    var senders = await peerConnection.getSenders();

    for (var element in senders) {
      peerConnection.removeTrack(element);
    }

    await _localVideo.dispose();
  }

  Future<void> _disposeRemote() async {
    var _stream = _remoteVideo.srcObject;
    if (_stream != null) {
      _stream.getTracks().forEach((element) async {
        await element.stop();
      });

      await _stream.dispose();
      _stream = null;
    }

    await _remoteVideo.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.85,
                child: Row(
                  children: [
                       Flexible(
                      child: VideoView(_localVideo, height: size.height,isMirrored: true,),
                    ),
                    Flexible(
                      child: VideoView(_remoteVideo, height: size.height),
                    ),
                  ],
                ),
              ),
              MeetingActionBar(
            iconSize: size.width * 0.03,
            isMicEnabled: isMicEnabled,
            isWebcamEnabled: isWebCamEnabled,
            onCallEndButtonPressed: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            onMicButtonPressed: () async {
              final stream = _localVideo.srcObject;
              if (stream != null) {
                stream.getTracks().forEach(
                  (track) {
                    if (track.kind == 'audio') {
                      track.enabled = !track.enabled;
                    }
                  },
                );
              
                setState(() {
                  isMicEnabled = !isMicEnabled;
                });
              }
            },
            onWebcamButtonPressed: () async {
              final stream = _localVideo.srcObject;
              if (stream != null) {
                stream.getTracks().forEach(
                  (track) {
                    if (track.kind == 'video') {
                      track.enabled = !track.enabled;
                    }
                  },
                );
                setState(() {
                  isWebCamEnabled = !isWebCamEnabled;
                });
              }
            },
          ),
            ],
          ),
        ),
      ),

    );
  }
}
