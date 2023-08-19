import 'package:flutter/material.dart';

import 'package:chat_app/widgets/new_message.dart';
import 'package:chat_app/widgets/chat_list.dart';

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({super.key});

  @override
  State<ChatMessageScreen> createState() => ChatMessageScreenState();
}

class ChatMessageScreenState extends State<ChatMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile.jpg'),
          // radius: 10,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
          left: 5,
          right: 5,
        ),
        child: Column(
          children: [
            Expanded(
              child: ChatList(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
