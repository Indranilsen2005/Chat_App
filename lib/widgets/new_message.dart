import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final messsage = _messageController.text;

    if (messsage.trim().isEmpty) {
      return;
    }
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    await FirebaseFirestore.instance.collection('chats').add({
      'chat_message': messsage,
      'createdAt': Timestamp.now(),
      'userID': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Type a message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: const Icon(Icons.message),
              prefixIconColor: Theme.of(context).colorScheme.primary,
            ),
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            enableSuggestions: true,
            controller: _messageController,
            style: const TextStyle(fontSize: 17),
          ),
        ),
        const SizedBox(width: 7),
        IconButton(
          style: IconButton.styleFrom(
            iconSize: 35,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _sendMessage,
          icon: const Icon(
            Icons.send,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
