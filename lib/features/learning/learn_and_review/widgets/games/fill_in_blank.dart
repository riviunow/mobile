import 'package:flutter/material.dart';
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
  TextEditingController answerController = TextEditingController();
  bool isAnswered = false;

  @override
  Widget build(BuildContext context) {
    final question = widget.gameOptions
        .firstWhere((option) => option.type == GameOptionType.question);
    final correctAnswer = widget.gameOptions
        .firstWhere((option) => option.type == GameOptionType.answer);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Fill in the blank",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            KnowledgeInfo(knowledge: widget.knowledge),
            const SizedBox(height: 16),
            Text(
              question.value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                hintText: 'Enter your answer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              enabled: !isAnswered,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                final userAnswer = answerController.text.trim();

                setState(() {
                  isAnswered = true;
                });
                widget.onAnswerSubmitted(userAnswer);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: answerController.text.trim().length !=
                        correctAnswer.value.length // not work here
                    ? null
                    : () {
                        final userAnswer = answerController.text.trim();

                        setState(() {
                          isAnswered = true;
                        });
                        widget.onAnswerSubmitted(userAnswer);
                      },
                child: const Text(
                  'Submit',
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
