import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/translation_service.dart';
import 'package:rvnow/shared/widgets/loader.dart';
import 'package:rvnow/shared/widgets/spaced_divider.dart';
import '../../blocs/game_bloc.dart';
import '../../models/playing_widget.dart';

class WordMatch extends StatefulWidget {
  final List<Knowledge> knowledgeList;

  const WordMatch({super.key, required this.knowledgeList});

  @override
  State<WordMatch> createState() => _WordMatchState();
}

class _WordMatchState extends State<WordMatch> {
  late final List<(String, String, String)>
      knowledgeTupples; // id / title / interpretation
  late final List<String> shuffledInterpretations;

  String? selectedTitle;
  String? selectedInterpretation;
  Map<String, String?> matchedPairs = {}; // title / interpretation
  Map<String, bool> matchResults = {}; // title or interpretation / is matched

  bool showTranslation = false;
  bool isLoading = false;
  late TranslationService translationService;

  @override
  void initState() {
    super.initState();

    translationService =
        Provider.of<TranslationService>(context, listen: false);

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
        : Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'match_the_knowledges'.tr(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        minHeight: 220,
                      ),
                      alignment: Alignment.bottomCenter,
                      child: _buildSelectableList(
                        items: knowledgeTupples.map((pair) => pair.$2).toList(),
                        isTitle: true,
                        selectedItem: selectedTitle,
                        textStyle:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SpacedDivider(
                      spacing: 12,
                    ),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        minHeight: 270,
                      ),
                      alignment: Alignment.topCenter,
                      child: _buildSelectableList(
                        items: shuffledInterpretations,
                        isTitle: false,
                        selectedItem: selectedInterpretation,
                        textStyle:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                matchedPairs.length == knowledgeTupples.length
                                    ? () => _submitResults(context)
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20.0),
                            ),
                            child: isLoading
                                ? const LoadingSmall()
                                : Text('submit_results'.tr(),
                                    style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
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
        final isInMatchedPairs =
            matchedPairs.containsKey(item) || matchedPairs.containsValue(item);
        final isInResults = matchResults.containsKey(item);

        Color borderColor;
        if (matchResults[item] == true && isInMatchedPairs) {
          borderColor = Colors.green;
        } else if (matchResults[item] == false) {
          borderColor = Colors.red;
        } else {
          borderColor = Colors.grey;
        }

        return GestureDetector(
          onTap: isInResults ? null : () => _handleSelection(item, isTitle),
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
        bool matchFound = widget.knowledgeList.any(
          (k) =>
              k.title == selectedTitle &&
              k.distinctInterpretation == selectedInterpretation,
        );

        if (isTitle) {
          matchResults[selectedInterpretation!] = matchFound;
          var titleOfSelectedInterpretation = knowledgeTupples
              .firstWhere((pair) => pair.$3 == selectedInterpretation)
              .$2;
          matchResults[titleOfSelectedInterpretation] = matchFound;
          matchedPairs[titleOfSelectedInterpretation] = selectedInterpretation;
        } else {
          matchResults[selectedTitle!] = matchFound;
          var interpretationOfSelectedTitle = knowledgeTupples
              .firstWhere((pair) => pair.$2 == selectedTitle)
              .$3;
          matchResults[interpretationOfSelectedTitle] = matchFound;
          matchedPairs[selectedTitle!] = interpretationOfSelectedTitle;
        }

        selectedTitle = null;
        selectedInterpretation = null;
      }
    });
  }

  void _submitResults(BuildContext context) {
    setState(() {
      isLoading = true;
    });

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
