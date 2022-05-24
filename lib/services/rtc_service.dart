import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../constants/configurations.dart';

class RTCService {
  late RTCPeerConnection peerConnection;
  late FirebaseFirestore videoapp;

  RTCService() {
    init();
    videoapp = FirebaseFirestore.instance;
  }

  Future<void> init() async{
        peerConnection = await createPeerConnection(configuration, offerSdpConstraints);
  }

  Future<String> call() async{
    // await init();
    final callDoc = videoapp.collection('calls').doc();
    final offerCandidates = callDoc.collection('offerCandidates');
    final answerCandidates = callDoc.collection('answerCandidates');

 peerConnection.onIceCandidate = (event) {
      if (event.candidate != null) offerCandidates.add(event.toMap());
    };
  
    callDoc.snapshots().listen(
      (snapshot) async {
        final data = snapshot.data();
        if ((await peerConnection.getRemoteDescription() == null) &&
            data!.containsKey('answer')) {
          final answerDescription = RTCSessionDescription(
              data['answer']['sdp'], data['answer']['type']);
          peerConnection.setRemoteDescription(answerDescription);
        }
      },
    );

    answerCandidates.snapshots().listen(
      (snapshot) async {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data()!;
            final candidate = RTCIceCandidate(
                data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
            peerConnection.addCandidate(candidate);
          }
        }
      },
    );

    final description = await peerConnection.createOffer();
    final offer = {
      'offer': {'sdp': description.sdp, 'type': description.type}
    };

    await peerConnection.setLocalDescription(description);
    await callDoc.set(offer);

    return callDoc.id;
  }

  Future<void> answer(String roomID) async{
    // await init();
    final callId = roomID;
    final callDoc = videoapp.collection('calls').doc(callId);
    final answerCandidates = callDoc.collection('answerCandidates');
    final offerCandidates = callDoc.collection('offerCandidates');

 peerConnection.onIceCandidate = (event) {
      if (event.candidate != null) answerCandidates.add(event.toMap());
    };

    final callData = (await callDoc.get()).data();

    final offerDescription = callData!['offer'];
    await peerConnection.setRemoteDescription(RTCSessionDescription(
        offerDescription['sdp'], offerDescription['type']));

    final description = await peerConnection.createAnswer();
    final answer = {
      'answer': {'sdp': description.sdp, 'type': description.type}
    };

    offerCandidates.snapshots().listen(
      (snapshot) async {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data()!;
            final candidate = RTCIceCandidate(
                data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
            peerConnection.addCandidate(candidate);

          }
        }
      },
    );

    await peerConnection.setLocalDescription(description);
    await callDoc.update(answer);

  }
  
  
}
