import 'package:flutter/material.dart';

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

  void _sendMessage() {
    final messsage = _messageController.text;

    if (messsage.isEmpty) {
      return;
    }

    // firebase logic

    _messageController.clear();
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
