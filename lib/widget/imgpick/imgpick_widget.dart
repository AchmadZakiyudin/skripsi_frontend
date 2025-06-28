import 'package:booking_bus/provider/imagepick_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagePickWidget extends StatefulWidget {
  const ImagePickWidget({super.key});

  @override
  State<ImagePickWidget> createState() => _ImagePickWidgetState();
}

class _ImagePickWidgetState extends State<ImagePickWidget> {
  @override
  Widget build(BuildContext context) {
    var loadpickimg = Provider.of<ImagePickProvider>(context);
    var getImage = loadpickimg.pickedImageFile;
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: getImage != null ? FileImage(getImage) : null,
        ),
        TextButton.icon(
          onPressed: () {
            loadpickimg.pickImage();
          },
          icon: const Icon(Icons.image),
          label: const Text("Upload Image"),
        )
      ],
    );
  }
}
