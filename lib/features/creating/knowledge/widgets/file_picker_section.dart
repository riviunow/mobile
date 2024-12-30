import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerSection extends StatelessWidget {
  final VoidCallback onPickAudio;
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;
  final List<XFile> selectedAudios;
  final List<XFile> selectedImages;
  final List<XFile> selectedVideos;

  const FilePickerSection({
    super.key,
    required this.onPickAudio,
    required this.onPickImage,
    required this.onPickVideo,
    required this.selectedAudios,
    required this.selectedImages,
    required this.selectedVideos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Files',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPickAudio,
          child: const Text('Select Audio'),
        ),
        if (selectedAudios.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Selected Audio: ${selectedAudios.first.name}'),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPickImage,
          child: const Text('Select Image'),
        ),
        if (selectedImages.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Image.file(
                  File(selectedImages.first.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                Text('Selected Image: ${selectedImages.first.name}'),
              ],
            ),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPickVideo,
          child: const Text('Select Video'),
        ),
        if (selectedVideos.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Selected Video: ${selectedVideos.first.name}'),
          ),
      ],
    );
  }
}
