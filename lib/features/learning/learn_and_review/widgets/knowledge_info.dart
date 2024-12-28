import 'package:flutter/material.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/constants/urls.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/audio_player.dart';

class KnowledgeInfo extends StatelessWidget {
  final Knowledge knowledge;
  const KnowledgeInfo({super.key, required this.knowledge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (knowledge.imageMaterials.isNotEmpty)
          SizedBox(
            height: 200,
            child: Image.network(
                "${Urls.mediaUrl}/${knowledge.imageMaterials.first.content}"),
          ),
        if (knowledge.audioMaterials.isNotEmpty)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...knowledge.audioMaterials.map((material) => Container(
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(4.0),
                      child: AudioPlayer(
                        url: material.content,
                      ),
                    )),
              ],
            ),
          ),
      ],
    );
  }
}
