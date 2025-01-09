import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
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
         Text(
          'files'.tr(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPickAudio,
          child: Text('select_audio'.tr()),
        ),
        if (selectedAudios.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPickImage,
          child: Text('select_image'.tr()),
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
              ],
            ),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPickVideo,
          child: Text('select_video'.tr()),
        ),
        if (selectedVideos.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
  }
}
