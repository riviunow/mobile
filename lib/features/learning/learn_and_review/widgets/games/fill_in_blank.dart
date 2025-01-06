import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/enums/game_option_type.dart';
import 'package:udetxen/shared/models/index.dart';

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

  @override
  void initState() {
    super.initState();
    final question = widget.gameOptions
        .firstWhere((option) => option.type == GameOptionType.question);

    controllers =
        List.generate(question.value.length, (_) => TextEditingController());
    focusNodes = List.generate(question.value.length, (_) => FocusNode());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes.isNotEmpty) {
        FocusScope.of(context).requestFocus(focusNodes[0]);
      }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final question = widget.gameOptions
  //       .firstWhere((option) => option.type == GameOptionType.question);
  //   controllers.clear();
  //   focusNodes.clear();
  //   for (int i = 0; i < question.value.length; i++) {
  //     controllers.add(TextEditingController());
  //     focusNodes.add(FocusNode());
  //   }
  // }

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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Fill in the blank",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            KnowledgeInfo(knowledge: widget.knowledge),
            const SizedBox(height: 24),
            Wrap(
              direction: Axis.horizontal,
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
                      if (value.length > 1) {
                        controllers[index].text = value.characters.last;
                      }

                      if (value.isNotEmpty && index < focusNodes.length - 1) {
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index + 1]);
                        controllers[index + 1].text =
                            controllers[index + 1].text;
                      } else if (value.isEmpty &&
                          index > 0 &&
                          (index == (controllers.length - 1) ||
                              controllers[index + 1].text.isEmpty)) {
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index - 1]);
                      }
                      setState(() {});
                    },
                    textInputAction: index == focusNodes.length - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    onSubmitted: (value) {
                      if (index == focusNodes.length - 1) {
                        if (value.isEmpty) {
                          return;
                        }
                        final userAnswer = controllers
                            .map((controller) => controller.text)
                            .join();
                        setState(() {
                          isAnswered = true;
                        });
                        widget.onAnswerSubmitted(userAnswer);
                      } else if (value.isNotEmpty) {
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index + 1]);
                        controllers[index + 1].text =
                            controllers[index + 1].text;
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
                onPressed: controllers.every((controller) =>
                            controller.text.trim().isNotEmpty) &&
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
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
