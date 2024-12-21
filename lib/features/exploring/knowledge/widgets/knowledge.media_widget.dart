import 'package:flutter/material.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/constants/urls.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/audio_player.dart';
import 'package:udetxen/shared/widgets/video_player.dart';

class KnowledgeMediaWidget extends StatefulWidget {
  final Knowledge knowledge;

  const KnowledgeMediaWidget({super.key, required this.knowledge});

  @override
  State<KnowledgeMediaWidget> createState() => _KnowledgeMediaWidgetState();
}

class _KnowledgeMediaWidgetState extends State<KnowledgeMediaWidget> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final knowledge = widget.knowledge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (knowledge.imageMaterials.isNotEmpty ||
            knowledge.videoMaterials.isNotEmpty) ...[
          SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                ...knowledge.imageMaterials.map(
                  (material) =>
                      Image.network("${Urls.mediaUrl}/${material.content}"),
                ),
                ...knowledge.videoMaterials.map(
                  (material) => VideoPlayer(url: material.content),
                ),
              ],
            ),
          ),
          if ((knowledge.imageMaterials.length +
                  knowledge.videoMaterials.length) >
              1) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                knowledge.imageMaterials.length +
                    knowledge.videoMaterials.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ]
        ],
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              Text(
                knowledge.title,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: knowledge.subTitles
                    .map((material) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(material.content,
                              style: const TextStyle(fontSize: 16)),
                        ))
                    .toList(),
              )
            ],
          ),
        ),
        const SizedBox(height: 4),
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
                      padding: const EdgeInsets.all(4.0),
                      margin: const EdgeInsets.all(2.0),
                      child: AudioPlayer(
                        url: material.content,
                      ),
                    )),
              ],
            ),
          ),
        const SizedBox(height: 4),
      ],
    );
  }
}
