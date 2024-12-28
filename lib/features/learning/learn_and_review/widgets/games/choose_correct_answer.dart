import 'package:flutter/material.dart';
import 'package:udetxen/shared/models/enums/game_option_type.dart';
import 'package:udetxen/shared/models/index.dart';

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
          const Text("Choose the correct answer",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(
            question.value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...answers.map((answer) => InkWell(
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
                      color:
                          selectedOption == answer ? Colors.blue : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          answer.value,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      if (isAnswered && selectedOption == answer)
                        Icon(
                          answer.isCorrect == true ? Icons.check : Icons.close,
                          color: answer.isCorrect == true
                              ? Colors.green
                              : Colors.red,
                        ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: selectedOption != null
                ? () {
                    setState(() {
                      isAnswered = true;
                    });
                    widget.onAnswerSubmitted(selectedOption!.value);
                  }
                : null,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
