import 'package:flutter/material.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/constants/urls.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/widgets/audio_player.dart';

class KnowledgeInfo extends StatelessWidget {
  final Knowledge knowledge;
  final double? imageHeight;
  const KnowledgeInfo({super.key, required this.knowledge, this.imageHeight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (knowledge.imageMaterials.isNotEmpty)
          SizedBox(
            height: imageHeight ?? 200,
            child: Image.network(
                "${Urls.mediaUrl}/${knowledge.imageMaterials.first.content}",
                fit: BoxFit.cover),
          ),
        if (knowledge.audioMaterials.isNotEmpty &&
            knowledge.imageMaterials.isEmpty)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...knowledge.audioMaterials.map((material) => Container(
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4.0),
                      margin: const EdgeInsets.all(2.0),
                      child: AudioPlayer(
                        url: material.content,
                      ),
                    )),
              ],
            ),
          ),
        if (knowledge.audioMaterials.isNotEmpty &&
            knowledge.imageMaterials.isNotEmpty)
          Positioned(
            bottom: 0,
            right: knowledge.imageMaterials.isNotEmpty ? 0 : null,
            left: knowledge.imageMaterials.isNotEmpty ? null : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: knowledge.audioMaterials
                  .map((material) => Container(
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        margin:
                            const EdgeInsets.only(left: 8, right: 2, bottom: 2),
                        padding: const EdgeInsets.all(4.0),
                        child: AudioPlayer(
                          url: material.content,
                        ),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
