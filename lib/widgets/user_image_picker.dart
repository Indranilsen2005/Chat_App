import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _userPickedImage;

  void _submit() async {
    final cameraPickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    final galleryPickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (cameraPickedImage == null && galleryPickedImage == null) {
      return;
    } else if (cameraPickedImage == null) {
      setState(() {
        _userPickedImage = File(galleryPickedImage!.path);
      });
    } else {
      setState(() {
        _userPickedImage = File(cameraPickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: FileImage(_userPickedImage!),
        ),
        TextButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
