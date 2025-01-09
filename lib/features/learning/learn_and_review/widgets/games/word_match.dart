import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/translation_service.dart';
import 'package:udetxen/shared/widgets/loader.dart';
import 'package:udetxen/shared/widgets/spaced_divider.dart';
import '../../blocs/game_bloc.dart';
import '../../models/playing_widget.dart';

class WordMatch extends StatefulWidget {
  final List<Knowledge> knowledgeList;

  const WordMatch({super.key, required this.knowledgeList});

  @override
  State<WordMatch> createState() => _WordMatchState();
}

class _WordMatchState extends State<WordMatch> {
  late List<(String, String, String)> knowledgeTupples;
  late List<String> shuffledInterpretations;

  String? selectedTitle;
  String? selectedInterpretation;
  Map<String, String?> matchedPairs = {};
  Map<String, bool> matchResults = {};

  bool showTranslation = false;
  late TranslationService translationService;

  @override
  void initState() {
    super.initState();

    translationService =
        Provider.of<TranslationService>(context, listen: false);
    showTranslation = translationService.showTranslationEn;

    if (widget.knowledgeList.length == 1) {
      final knowledgeToAnswers = <String, WordMatchAnswer>{
        widget.knowledgeList.first.id: WordMatchAnswer(
          interpretation: widget.knowledgeList.first.distinctInterpretation!,
          wordMatchAnswer: widget.knowledgeList.first.distinctInterpretation!,
        ),
      };

      context.read<GameBloc>().add(WordMatchFinished(knowledgeToAnswers));
    }
    knowledgeTupples = widget.knowledgeList
        .map((k) => (k.id, k.title, k.distinctInterpretation!))
        .toList();
    shuffledInterpretations = knowledgeTupples.map((pair) => pair.$3).toList()
      ..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return widget.knowledgeList.length == 1
        ? const Loading()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'match_the_knowledges'.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    child: _buildSelectableList(
                      items: knowledgeTupples.map((pair) => pair.$2).toList(),
                      isTitle: true,
                      selectedItem: selectedTitle,
                      textStyle:
                          const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SpacedDivider(
                  spacing: 12,
                ),
                Flexible(
                  flex: 4,
                  child: SizedBox(
                    child: _buildSelectableList(
                      items: shuffledInterpretations,
                      isTitle: false,
                      selectedItem: selectedInterpretation,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: showTranslation,
                          onChanged: (value) {
                            setState(() {
                              showTranslation = value;
                            });
                          },
                        ),
                        Icon(Icons.translate,
                            color: showTranslation
                                ? Theme.of(context).primaryColor
                                : AppColors.hint),
                      ],
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            matchedPairs.length == knowledgeTupples.length
                                ? () => _submitResults(context)
                                : null,
                        child: Text('submit_results'.tr(),
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _buildSelectableList({
    required List<String?> items,
    required bool isTitle,
    required String? selectedItem,
    required TextStyle textStyle,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedItem == item;
        final isMatched =
            matchedPairs.containsKey(item) || matchedPairs.containsValue(item);

        Color borderColor = Colors.grey;
        if (isMatched) {
          if (matchResults[item] == true) {
            borderColor = Colors.green;
          } else if (matchResults[item] == false) {
            borderColor = Colors.red;
          }
        }

        return GestureDetector(
          onTap: isMatched ? null : () => _handleSelection(item, isTitle),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            color: (isSelected ? Colors.blue[300] : Colors.grey[300])
                ?.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: showTranslation
                  ? FutureBuilder<String>(
                      future: translationService.translate(item ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.hint,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const SizedBox();
                        } else {
                          return Text(
                            snapshot.data ?? '',
                            style: textStyle,
                          );
                        }
                      },
                    )
                  : Text(
                      item ?? '',
                      style: textStyle,
                    ),
            ),
          ),
        );
      },
    );
  }

  void _handleSelection(String? item, bool isTitle) {
    setState(() {
      if (isTitle) {
        if (selectedTitle == item) {
          selectedTitle = null;
        } else {
          selectedTitle = item;
        }
      } else {
        if (selectedInterpretation == item) {
          selectedInterpretation = null;
        } else {
          selectedInterpretation = item;
        }
      }

      if (selectedTitle != null && selectedInterpretation != null) {
        matchedPairs[selectedTitle!] = selectedInterpretation;

        bool matchFound = widget.knowledgeList.any(
          (k) =>
              k.title == selectedTitle &&
              k.distinctInterpretation == selectedInterpretation,
        );

        matchResults[selectedTitle!] = matchFound;
        matchResults[selectedInterpretation!] = matchFound;

        selectedTitle = null;
        selectedInterpretation = null;
      }
    });
  }

  void _submitResults(BuildContext context) {
    final knowledgeToAnswers = <String, WordMatchAnswer>{};

    for (var pair in knowledgeTupples) {
      knowledgeToAnswers[pair.$1] = WordMatchAnswer(
        interpretation: pair.$3,
        wordMatchAnswer: matchedPairs[pair.$2] ?? '',
      );
    }

    context.read<GameBloc>().add(WordMatchFinished(knowledgeToAnswers));
  }
}
