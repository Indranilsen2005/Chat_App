import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

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
              height: 400,
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Set Profile Picture',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  // const SizedBox(height: 25),
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.grey,
                    foregroundImage: _userPickedImage != null
                        ? FileImage(_userPickedImage!)
                        : null,
                  ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
