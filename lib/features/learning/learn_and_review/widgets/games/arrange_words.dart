import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
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
  late List<(String, bool, int)> shuffledWords;
  late List<(String, int)> arrangedWords;
  bool isAnswered = false;
  late bool hasSpace;

  @override
  void initState() {
    super.initState();
    String question = widget.gameOptions
        .firstWhere((option) => option.type == GameOptionType.question)
        .value;
    hasSpace = question.contains(' ');
    shuffledWords = (hasSpace ? question.split(" ") : question.split(''))
        .asMap()
        .entries
        .map((entry) => (entry.value, false, entry.key))
        .toList();
    arrangedWords = [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("arrange_the_words".tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              KnowledgeInfo(knowledge: widget.knowledge, imageHeight: 150),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 200,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 4),
                      child: arrangedWords.isEmpty
                          ? Text(
                              "click_to_arrange".tr(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).hintColor,
                              ),
                            )
                          : SingleChildScrollView(
                              child: ReorderableWrap(
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                spacing: 2.0,
                                runSpacing: 2.0,
                                onReorder: (int oldIndex, int newIndex) =>
                                    setState(() {
                                  final word = arrangedWords.removeAt(oldIndex);
                                  arrangedWords.insert(newIndex, word);
                                }),
                                needsLongPressDraggable: true,
                                children: arrangedWords
                                    .map((tupple) => GestureDetector(
                                          onTap: () => setState(() {
                                            shuffledWords = shuffledWords
                                                .map((t) => t.$3 == tupple.$2
                                                    ? (t.$1, false, t.$3)
                                                    : t)
                                                .toList();
                                            arrangedWords.removeWhere(
                                                (e) => e.$2 == tupple.$2);
                                          }),
                                          child: Card(
                                            key: ValueKey(tupple.$1),
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.8),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 22.0,
                                                      vertical: 10),
                                              child: Text(tupple.$1,
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor)),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 200,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: shuffledWords.isEmpty
                    ? Center(
                        child: Text(
                          'all_are_choosen'.tr(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: shuffledWords
                              .map((tupple) => GestureDetector(
                                    onTap: tupple.$2
                                        ? null
                                        : () => setState(() {
                                              arrangedWords
                                                  .add((tupple.$1, tupple.$3));
                                              shuffledWords = shuffledWords
                                                  .map((t) => t.$3 == tupple.$3
                                                      ? (t.$1, true, t.$3)
                                                      : t)
                                                  .toList();
                                            }),
                                    child: Container(
                                      key: ValueKey(tupple.$1),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: tupple.$2
                                                ? Theme.of(context)
                                                    .scaffoldBackgroundColor
                                                : Theme.of(context)
                                                    .primaryColor),
                                        color: tupple.$2
                                            ? Theme.of(context)
                                                .scaffoldBackgroundColor
                                            : Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 22.0, vertical: 10),
                                        child: Text(tupple.$1,
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor)),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: shuffledWords.length == arrangedWords.length
                    ? () {
                        final userAnswer = arrangedWords
                            .map((t) => t.$1)
                            .join(hasSpace ? ' ' : "");
                        setState(() {
                          isAnswered = true;
                        });
                        widget.onAnswerSubmitted(userAnswer);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    backgroundColor: AppColors.secondary),
                child: Text(
                  'submit'.tr(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )),
      ],
    );
  }
}
