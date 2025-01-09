import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/enums/game_option_type.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/translation_service.dart';

class ChooseCorrectAnswer extends StatefulWidget {
  final List<GameOption> gameOptions;
  final void Function(String) onAnswerSubmitted;

  const ChooseCorrectAnswer(
      {super.key, required this.gameOptions, required this.onAnswerSubmitted});

  @override
  State<ChooseCorrectAnswer> createState() => _ChooseCorrectAnswerState();
}

class _ChooseCorrectAnswerState extends State<ChooseCorrectAnswer> {
  GameOption? selectedOption;
  bool isAnswered = false;

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
    final question = widget.gameOptions
        .firstWhere((option) => option.type == GameOptionType.question);
    final answers = widget.gameOptions
        .where((option) => option.type == GameOptionType.answer)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("choose_the_correct_answer".tr(),
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(
            question.value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: answers
                  .map((answer) => InkWell(
                        onTap: isAnswered
                            ? null
                            : () {
                                setState(() {
                                  selectedOption = answer;
                                });
                              },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: selectedOption == answer
                                ? Colors.blue.withOpacity(0.2)
                                : null,
                            border: Border.all(
                              color: selectedOption == answer
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      answer.value,
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    if (showTranslation == true)
                                      FutureBuilder<String>(
                                        future: translationService
                                            .translate(answer.value),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container(
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: AppColors.hint,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const SizedBox();
                                          } else {
                                            return Text(
                                              snapshot.data ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      color: AppColors.hint),
                                            );
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              if (isAnswered && selectedOption == answer)
                                Icon(
                                  answer.isCorrect == true
                                      ? Icons.check
                                      : Icons.close,
                                  color: answer.isCorrect == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          if (!isAnswered)
            Row(
              children: [
                Row(
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedOption != null
                        ? () {
                            setState(() {
                              isAnswered = true;
                            });
                          }
                        : null,
                    child: Text('submit'.tr()),
                  ),
                ),
              ],
            )
          else
            ElevatedButton(
              onPressed: selectedOption == null
                  ? null
                  : () => widget.onAnswerSubmitted(selectedOption!.value),
              child: Text('next'.tr()),
            )
        ],
      ),
    );
  }
}
