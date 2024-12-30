import 'package:flutter/material.dart';

class SpacedDivider extends StatelessWidget {
  final double spacing;

  const SpacedDivider({super.key, this.spacing = 16.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: spacing),
        const Divider(),
        SizedBox(height: spacing),
      ],
    );
  }
}
