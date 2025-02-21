import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/enums/game_option_type.dart';
import 'package:rvnow/shared/models/index.dart';

import '../knowledge_info.dart';

class FillInBlank extends StatefulWidget {
  final List<GameOption> gameOptions;
  final Knowledge knowledge;
  final void Function(String) onAnswerSubmitted;

  const FillInBlank(
      {super.key,
      required this.gameOptions,
      required this.onAnswerSubmitted,
      required this.knowledge});

  @override
  State<FillInBlank> createState() => _FillInBlankState();
}

class _FillInBlankState extends State<FillInBlank> {
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  bool isAnswered = false;
  List<bool> hasValue = [];
  static const zeroWidthSpace = '\u200b';

  @override
  void initState() {
    super.initState();
    final question = widget.gameOptions
        .firstWhere((option) => option.type == GameOptionType.question);

    controllers = List.generate(question.value.length, (index) {
      final controller = TextEditingController(text: zeroWidthSpace);
      return controller;
    });
    focusNodes = List.generate(question.value.length, (_) => FocusNode());
    hasValue = List.generate(question.value.length, (_) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes.isNotEmpty) {
        FocusScope.of(context).requestFocus(focusNodes[0]);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.gameOptions
        .firstWhere((option) => option.type == GameOptionType.question);
    final correctAnswer = widget.gameOptions.firstWhere((option) =>
        option.type == GameOptionType.answer && option.isCorrect == true);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "fill_in_the_blank".tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (widget.knowledge.imageMaterials.isNotEmpty ||
              widget.knowledge.audioMaterials.isNotEmpty)
            KnowledgeInfo(knowledge: widget.knowledge),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4.0,
            runSpacing: 8.0,
            children: List.generate(question.value.length, (index) {
              return SizedBox(
                width: 40,
                child: TextField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  decoration: InputDecoration(
                    hintText: question.value[index],
                    hintStyle: TextStyle(
                        color: AppColors.hint.withOpacity(0.5), fontSize: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  enabled: !isAnswered,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                  onChanged: (value) {
                    var isValued = hasValue[index];

                    if (value.isEmpty || value == zeroWidthSpace) {
                      controllers[index].text = zeroWidthSpace;
                      hasValue[index] = false;
                    } else if (value.length > 1) {
                      String changedValue = value;
                      if (isValued) {
                        changedValue = changedValue.substring(
                            changedValue.length - 2, changedValue.length - 1);
                      }
                      controllers[index].text = changedValue.characters.last;
                      hasValue[index] = true;
                    }

                    controllers[index].selection = TextSelection.fromPosition(
                        TextPosition(offset: controllers[index].text.length));

                    if (value.isNotEmpty && index < focusNodes.length - 1) {
                      FocusScope.of(context)
                          .requestFocus(focusNodes[index + 1]);
                    } else if (value.trim().isEmpty && index > 0 && !isValued) {
                      FocusScope.of(context)
                          .requestFocus(focusNodes[index - 1]);
                      if (controllers[index - 1].text.isNotEmpty) {
                        controllers[index - 1].text = zeroWidthSpace;
                        hasValue[index - 1] = false;
                      }
                    }
                    setState(() {});
                  },
                  textInputAction: index == focusNodes.length - 1
                      ? TextInputAction.done
                      : TextInputAction.next,
                  onSubmitted: (value) {
                    if (index == focusNodes.length - 1) {
                      if (value.isEmpty || value == zeroWidthSpace) {
                        FocusScope.of(context).requestFocus(focusNodes[index]);
                      } else {
                        final userAnswer = controllers
                            .map((controller) => controller.text.trim())
                            .join();
                        setState(() {
                          isAnswered = true;
                        });
                        widget.onAnswerSubmitted(userAnswer);
                      }
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controllers.every(
                          (controller) => controller.text.trim().isNotEmpty) &&
                      controllers.length == correctAnswer.value.length
                  ? () {
                      final userAnswer = controllers
                          .map((controller) => controller.text)
                          .join();
                      setState(() {
                        isAnswered = true;
                      });
                      widget.onAnswerSubmitted(userAnswer);
                    }
                  : null,
              child: Text(
                'next'.tr(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
