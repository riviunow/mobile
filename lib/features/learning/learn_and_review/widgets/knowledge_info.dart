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
    return Stack(
      children: [
        if (knowledge.imageMaterials.isNotEmpty)
          SizedBox(
            height: 200,
            child: Image.network(
                "${Urls.mediaUrl}/${knowledge.imageMaterials.first.content}"),
          ),
        if (knowledge.audioMaterials.isNotEmpty)
          Positioned(
            bottom: 0,
            right: knowledge.imageMaterials.isNotEmpty ? 0 : null,
            left: knowledge.imageMaterials.isNotEmpty ? null : 0,
            child: Row(
              mainAxisAlignment: knowledge.imageMaterials.isNotEmpty
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
              children: [
                ...knowledge.audioMaterials.map((material) => Container(
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
                    )),
              ],
            ),
          ),
      ],
    );
  }
}
