import 'package:easy_localization/easy_localization.dart';
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
            child: Text('back'.tr()),
          ),
          if (currentStep < 4)
            ElevatedButton(
              onPressed: onNext,
              child: Text('next'.tr()),
            ),
          if (currentStep == 4 && onSubmit != null)
            ElevatedButton(
              onPressed: onSubmit,
              child: Text('submit'.tr()),
            ),
        ],
      ),
    );
  }
}
