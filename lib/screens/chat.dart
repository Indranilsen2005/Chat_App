import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/widgets/chat_list.dart';
import 'package:chat_app/screens/users_list.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ChatOn',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              try {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (ctx) => const AuthScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              } catch (error) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Something went wrong! Please check your internet connection and try again later.'),
                  ),
                );
              }
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UsersListScreen(),
            ),
          );
        },
        iconSize: 23,
        padding: const EdgeInsets.all(20),
        icon: Icon(Icons.message_rounded),
        color: Colors.white,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: ChatList(),
            ),
          ],
        ),
      ),
    );
  }
}
