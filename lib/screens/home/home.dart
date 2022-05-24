import 'package:flutter/material.dart';

import '../create_room/create_room.dart';
import '../join_room/join_room.dart';
import '/constants/styles.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.06,
                width: size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreateRoom())),
                  child: const Text('Create Room'),
                  style: RoundedButtonStyle,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: size.height * 0.06,
                width: size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const JoinRoom())),
                  child: const Text('Join Room'),
                  style: RoundedButtonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
