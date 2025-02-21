import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rvnow/shared/models/enums/game_option_type.dart';
import 'package:rvnow/shared/models/index.dart';

import '../knowledge_info.dart';

class ArrangeWords extends StatefulWidget {
  final List<GameOption> gameOptions;
  final Knowledge knowledge;
  final void Function(String) onAnswerSubmitted;

  const ArrangeWords({
    super.key,
    required this.gameOptions,
    required this.onAnswerSubmitted,
    required this.knowledge,
  });

  @override
  State<ArrangeWords> createState() => _ArrangeWordsState();
}

class _ArrangeWordsState extends State<ArrangeWords> {
  late List<String> shuffledWords;
  late List<String> arrangedWords;
  bool isAnswered = false;
  late bool hasSpace;

  @override
  void initState() {
    super.initState();
    String question = widget.gameOptions
        .firstWhere((option) => option.type == GameOptionType.question)
        .value;
    hasSpace = question.contains(' ');
    shuffledWords = hasSpace ? question.split(" ") : question.split('');
    arrangedWords = [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("arrange_the_words".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              KnowledgeInfo(knowledge: widget.knowledge, imageHeight: 150),
              _buildWordCard(
                arrangedWords,
                (String word) => setState(() {
                  shuffledWords.add(word);
                  arrangedWords.remove(word);
                }),
                (int oldIndex, int newIndex) => setState(() {
                  final word = arrangedWords.removeAt(oldIndex);
                  arrangedWords.insert(newIndex, word);
                }),
                isAnswer: true,
              ),
              _buildWordCard(
                  shuffledWords,
                  (String word) => setState(() {
                        arrangedWords.add(word);
                        shuffledWords.remove(word);
                      }),
                  (int oldIndex, int newIndex) => setState(() {
                        final word = shuffledWords.removeAt(oldIndex);
                        shuffledWords.insert(newIndex, word);
                      })),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: shuffledWords.isEmpty
                    ? () {
                        final userAnswer =
                            arrangedWords.join(hasSpace ? ' ' : "");
                        setState(() {
                          isAnswered = true;
                        });
                        widget.onAnswerSubmitted(userAnswer);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'submit'.tr(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildWordCard(List<String> words, void Function(String word) onTap,
      void Function(int oldIndex, int newIndex) onReorder,
      {bool isAnswer = false}) {
    return Container(
      width: double.infinity,
      constraints: words.isEmpty
          ? const BoxConstraints(minHeight: 80)
          : const BoxConstraints(
              minHeight: 200,
            ),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: words.isEmpty
          ? Center(
              child: Text(
                isAnswer ? "click_to_arrange".tr() : 'all_are_choosen'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).hintColor,
                ),
              ),
            )
          : SingleChildScrollView(
              child: ReorderableWrap(
                spacing: 4.0,
                runSpacing: 4.0,
                onReorder: onReorder,
                needsLongPressDraggable: true,
                children: words
                    .map((word) => GestureDetector(
                          onTap: () => onTap(word),
                          child: Card(
                            key: ValueKey(word),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 8),
                              child: Text(word,
                                  style: TextStyle(
                                      fontSize: 26,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor)),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
    );
  }
}
