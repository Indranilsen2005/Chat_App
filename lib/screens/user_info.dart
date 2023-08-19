import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chat_app/screens/chat.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({
    super.key,
    required this.userCredentials,
    required this.userEmail,
  });

  final UserCredential userCredentials;
  final String userEmail;

  @override
  State<UserInfoScreen> createState() => UserInfoScreenState();
}

class UserInfoScreenState extends State<UserInfoScreen> {
  final _form = GlobalKey<FormState>();

  File? _userPickedImage;
  var _isUploading = false;
  var _username = '';
  String? _imageUrl;

  void _submitImageFromCamera() async {
    final cameraPickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (cameraPickedImage == null) {
      return;
    }

    setState(() {
      _userPickedImage = File(cameraPickedImage.path);
    });
  }

  void _submitImageFromGallery() async {
    final galleryPickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (galleryPickedImage == null) {
      return;
    }

    setState(() {
      _userPickedImage = File(galleryPickedImage.path);
    });
  }

  void _saveAndContinue() async {
    if (_userPickedImage == null || !_form.currentState!.validate()) {
      setState(() {
        _isUploading = false;
      });
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isUploading = true;
    });

    if (_userPickedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${widget.userCredentials.user!.uid}.jpeg');

      await storageRef.putFile(_userPickedImage!);
      _imageUrl = await storageRef.getDownloadURL();
    }

    final firestoreData = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userCredentials.user!.uid);
    await firestoreData.set({
      'username': _username,
      'email': widget.userEmail,
      'image_url': _userPickedImage != null ? _imageUrl : null,
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
      (Route<dynamic> route) => false,
    );

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget profilePicture = const CircleAvatar(
      radius: 90,
      backgroundColor: Colors.grey,
      backgroundImage: AssetImage('assets/images/profile.jpg'),
    );

    if (_userPickedImage != null) {
      profilePicture = CircleAvatar(
        radius: 90,
        foregroundImage: FileImage(_userPickedImage!),
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Card(
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 50,
                horizontal: 20,
              ),
              height: 550,
              width: 300,
              child: SingleChildScrollView(
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
                    profilePicture,
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
                    const SizedBox(height: 30),
                    Form(
                      key: _form,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) != null) {
                            return 'Please enter a valid username.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        maxLength: 50,
                        onSaved: (newValue) {
                          _username = newValue!;
                        },
                      ),
                    ),
                    const SizedBox(height: 60),
                    if (_isUploading) const CircularProgressIndicator(),
                    if (!_isUploading)
                      ElevatedButton(
                        onPressed: _saveAndContinue,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 80,
                          ),
                          backgroundColor: Color.fromARGB(255, 12, 18, 188),
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
      ),
    );
  }
}
