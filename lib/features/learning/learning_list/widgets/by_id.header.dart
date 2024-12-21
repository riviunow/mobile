import 'package:flutter/material.dart';

class ByIdHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onMore;

  const ByIdHeader({
    super.key,
    required this.onBack,
    required this.onSearch,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back,
              size: 32, color: Theme.of(context).primaryColor),
          onPressed: onBack,
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: onSearch,
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMore,
            ),
          ],
        ),
      ],
    );
  }
}
