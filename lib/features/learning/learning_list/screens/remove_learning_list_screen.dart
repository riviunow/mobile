import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/remove_learning_list_bloc.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

class RemoveLearningListScreen extends StatefulWidget {
  final LearningList learningList;

  static route(LearningList learningList) {
    return MaterialPageRoute<void>(
      builder: (_) => RemoveLearningListScreen(learningList: learningList),
    );
  }

  const RemoveLearningListScreen({super.key, required this.learningList});

  @override
  State<RemoveLearningListScreen> createState() =>
      _RemoveLearningListScreenState();
}

class _RemoveLearningListScreenState extends State<RemoveLearningListScreen> {
  void _removeLearningList() {
    context
        .read<RemoveLearningListBloc>()
        .add(RemoveLearningListRequested(widget.learningList.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RemoveLearningListBloc, RemoveLearningListState>(
        listener: (context, state) {
          if (state is RemoveLearningListSuccess) {
            Navigator.of(context).pop(state.learningList);
          } else if (state is RemoveLearningListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.messages.join('\n')}')),
            );
          }
        },
        builder: (context, state) {
          if (state is RemoveLearningListLoading) {
            return const Center(child: Loading());
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${"this_list_contains".tr()} (${widget.learningList.learningListKnowledges.length}).',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text('are_you_sure_to_remove_this_learning_list'.tr()),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('cancel'.tr()),
                      ),
                      ElevatedButton(
                        onPressed: _removeLearningList,
                        child: Text('remove'.tr()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
