import 'package:flutter/material.dart';
import 'package:udetxen/shared/models/enums/game_option_type.dart';
import 'package:udetxen/shared/models/index.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Arrange the words",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          KnowledgeInfo(knowledge: widget.knowledge),
          const SizedBox(height: 16),
          _buildWordCard((String word) {
            setState(() {
              shuffledWords.add(word);
              arrangedWords.remove(word);
            });
          }),
          const SizedBox(height: 16),
          _buildWordCard((String word) {
            setState(() {
              arrangedWords.add(word);
              shuffledWords.remove(word);
            });
          }),
          const SizedBox(height: 24),
          SizedBox(
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(void Function(String word) onTap) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: arrangedWords
          .map((word) => GestureDetector(
                onTap: () => onTap(word),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(word, style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
