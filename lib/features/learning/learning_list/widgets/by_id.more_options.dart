import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rvnow/shared/models/index.dart';

import '../screens/remove_learning_list_screen.dart';
import '../screens/update_learning_list_screen.dart';

class ByIdMoreOptions extends StatelessWidget {
  final LearningList learningList;

  const ByIdMoreOptions({super.key, required this.learningList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, size: 28),
            title: Text('update'.tr(), style: const TextStyle(fontSize: 18)),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(
                  context, UpdateLearningListScreen.route(learningList));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, size: 28),
            title: Text('remove'.tr(), style: const TextStyle(fontSize: 18)),
            onTap: () async {
              var result = await Navigator.push(
                  context, RemoveLearningListScreen.route(learningList));
              result != null
                  ? Navigator.pop(context, result)
                  : Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
