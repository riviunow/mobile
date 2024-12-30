import 'package:flutter/material.dart';

class StepStatusBar extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepTapped;

  const StepStatusBar({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () => onStepTapped(index),
              child: CircleAvatar(
                radius: 15,
                backgroundColor:
                    currentStep == index ? Colors.blue : Colors.grey,
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: currentStep == index ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
