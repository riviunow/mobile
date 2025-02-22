import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rvnow/features/exploring/knowledge/widgets/knowledge.material_list.dart';
import 'package:rvnow/features/exploring/knowledge/widgets/knowledge.media_widget.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/index.dart' as models;
import 'package:rvnow/shared/services/translation_service.dart';

import '../blocs/game_bloc.dart';

class FlashCard extends StatefulWidget {
  final models.Knowledge knowledge;

  const FlashCard({super.key, required this.knowledge});

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool isFront = true;
  bool isFlipped = false;
  bool showTranslation = false;
  late TranslationService translationService;

  @override
  void initState() {
    super.initState();
    translationService =
        Provider.of<TranslationService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isFront = !isFront;
              isFlipped = true;
            });
          },
          child: Card(
            margin: const EdgeInsets.only(top: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.95,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                  return AnimatedBuilder(
                    animation: rotate,
                    child: child,
                    builder: (context, child) {
                      final isUnder = ValueKey(isFront) != child!.key;
                      var tilt = (animation.value - 0.5).abs() - 0.5;
                      tilt *= isUnder ? -0.003 : 0.003;
                      final value =
                          isUnder ? min(rotate.value, pi / 2) : rotate.value;
                      return Transform(
                        transform: Matrix4.rotationY(value)
                          ..setEntry(3, 0, tilt),
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                  );
                },
                child: isFront ? _buildFrontView() : _buildBackView(),
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: AppColors.secondary),
              onPressed: isFlipped
                  ? () {
                      context.read<GameBloc>().add(
                            FlashCardFinished(widget.knowledge.id),
                          );
                    }
                  : null,
              child: Text('next'.tr(), style: const TextStyle(fontSize: 22)),
            ))
      ],
    );
  }

  Widget _buildFrontView() {
    return Container(
      alignment: Alignment.center,
      key: const ValueKey('FrontView'),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KnowledgeMediaWidget(knowledge: widget.knowledge),
        ],
      ),
    );
  }

  Widget _buildBackView() {
    return Container(
      key: const ValueKey('BackView'),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7 - 32,
              ),
              child: SingleChildScrollView(
                child: KnowledgeMaterialList(
                    materials: widget.knowledge.restMaterials,
                    isFirstLayer: true,
                    showTranslation: showTranslation,
                    translationService: translationService),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                Icon(Icons.translate,
                    color: showTranslation
                        ? Theme.of(context).primaryColor
                        : AppColors.hint),
                Switch(
                  value: showTranslation,
                  onChanged: (value) {
                    setState(() {
                      showTranslation = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
