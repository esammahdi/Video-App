import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

import '../../constants/styles.dart';
import '../../services/rtc_service.dart';
import '../room/room.dart';
import '../widgets/video_view.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({Key? key}) : super(key: key);

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final controller = TextEditingController();
  final localVideo = RTCVideoRenderer();
  late RTCService peerService;

  @override
  didChangeDependencies() async {
    peerService = Provider.of<RTCService>(context, listen: false);

    await openCamera();

    super.didChangeDependencies();
  }

@override
void deactivate() async {
  await _disposeLocal();
  super.deactivate();
}

  @override
  void dispose() async {
    controller.dispose();
    await _disposeLocal();
    super.dispose();
  }

  Future<void> _disposeLocal() async {
    var _stream = localVideo.srcObject;

    if (_stream != null) {
      _stream.getTracks().forEach(
        (element) async {
          await element.stop();
        },
      );

      await _stream.dispose();
      _stream = null;
    }

    var senders = await peerService.peerConnection.getSenders();

    for (var element in senders) {
      peerService.peerConnection.removeTrack(element);
    }

    await localVideo.dispose();
  }


  Future<void> openCamera() async {
    await localVideo.initialize();
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    stream
        .getTracks()
        .forEach((track) => peerService.peerConnection.addTrack(track, stream));
    localVideo.srcObject = stream;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: Hero(tag : 'localVideo', child: VideoView(localVideo, isMirrored: true)),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'RoomID',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: size.height * 0.06,
              width: size.width * 0.7,
              child: ElevatedButton(
                onPressed: () async {
                  String roomId = controller.text;
                  await peerService.answer(roomId);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Room(localVideo.srcObject)));
                },
                child: const Text('Join'),
                style: RoundedButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
