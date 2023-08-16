import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({
    super.key,
    required this.userCredentials,
  });

  final UserCredential userCredentials;

  @override
  State<UserInfoScreen> createState() => UserInfoScreenState();
}

class UserInfoScreenState extends State<UserInfoScreen> {
  File? _userPickedImage;

  void _submitImageFromCamera() async {
    final cameraPickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (cameraPickedImage == null) {
      return;
    }

    setState(() {
      _userPickedImage = File(cameraPickedImage.path);
    });
  }

  void _submitImageFromGallery() async {
    final galleryPickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (galleryPickedImage == null) {
      return;
    }

    setState(() {
      _userPickedImage = File(galleryPickedImage.path);
    });
  }

  void _submit() {
    if (_userPickedImage == null) {
      return;
    }

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${widget.userCredentials.user!.uid}.jpeg');

      storageRef.putFile(_userPickedImage!);
      final imageUrl = storageRef.getDownloadURL();
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong! Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 50,
                horizontal: 20,
              ),
              height: 450,
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Set Profile Picture',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.grey,
                    foregroundImage: _userPickedImage != null
                        ? FileImage(_userPickedImage!)
                        : null,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _submitImageFromCamera,
                        icon: const Icon(Icons.camera),
                        label: const Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _submitImageFromGallery,
                        icon: const Icon(Icons.image),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 80,
                      ),
                      backgroundColor: const Color.fromARGB(255, 89, 12, 176),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Save & Continue',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
