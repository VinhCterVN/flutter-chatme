import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Chat Page'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to another screen or perform an action
            },
            child: const Text('Start Chatting'),
          ),
        ],
      ),
    );
  }
}
