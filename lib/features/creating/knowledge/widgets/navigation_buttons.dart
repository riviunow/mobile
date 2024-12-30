import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback? onSubmit;

  const NavigationButtons({
    super.key,
    required this.currentStep,
    required this.onBack,
    required this.onNext,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: currentStep > 0 ? onBack : null,
            child: const Text('Back'),
          ),
          if (currentStep < 4)
            ElevatedButton(
              onPressed: onNext,
              child: const Text('Next'),
            ),
          if (currentStep == 4 && onSubmit != null)
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text('Submit'),
            ),
        ],
      ),
    );
  }
}
