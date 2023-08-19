import 'package:chat_app/screens/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Chat'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, userSnapshots) {
          if (userSnapshots.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!userSnapshots.hasData || userSnapshots.data!.docs.isEmpty) {
            return Center(
              child: Text('No users found...'),
            );
          }

          if (userSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong! Please try again later.'),
            );
          }

          final loadedUsers = userSnapshots.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            itemCount: loadedUsers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => ChatMessageScreen()),
                      ModalRoute.withName('/'),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                    foregroundImage:
                        NetworkImage(loadedUsers[index].data()['image_url']),
                    radius: 25,
                  ),
                  title: Text(
                    loadedUsers[index].data()['username'],
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
