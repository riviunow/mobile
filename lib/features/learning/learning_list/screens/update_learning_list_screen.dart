import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learning_list/blocs/update_learning_list_bloc.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/widgets/loader.dart';

import '../models/update_learning_list.dart';

class UpdateLearningListScreen extends StatefulWidget {
  final LearningList learningList;

  static route(LearningList ll) {
    return MaterialPageRoute<void>(
      builder: (_) => UpdateLearningListScreen(learningList: ll),
    );
  }

  const UpdateLearningListScreen({super.key, required this.learningList});

  @override
  State<UpdateLearningListScreen> createState() =>
      _UpdateLearningListScreenState();
}

class _UpdateLearningListScreenState extends State<UpdateLearningListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.learningList.title;
  }

  void _updateLearningList() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = UpdateLearningListRequest(
        id: widget.learningList.id,
        title: _titleController.text,
      );
      context
          .read<UpdateLearningListBloc>()
          .add(UpdateLearningListRequested(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UpdateLearningListBloc, UpdateLearningListState>(
        listener: (context, state) {
          if (state is UpdateLearningListSuccess) {
            Navigator.of(context).pop(state.learningList);
          } else if (state is UpdateLearningListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.messages.join('\n')}')),
            );
          }
        },
        builder: (context, state) {
          if (state is UpdateLearningListLoading) {
            return const Center(child: Loading());
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _updateLearningList();
                      },
                    ),
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
                          onPressed: _updateLearningList,
                          child: Text('update'.tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
