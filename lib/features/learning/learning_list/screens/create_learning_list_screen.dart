import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/create_learning_list_bloc.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import '../models/create_learning_list.dart';

class CreateLearningListScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CreateLearningListScreen(),
    );
  }

  const CreateLearningListScreen({super.key});

  @override
  State<CreateLearningListScreen> createState() =>
      _CreateLearningListScreenState();
}

class _CreateLearningListScreenState extends State<CreateLearningListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  void _createLearningList() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = CreateLearningListRequest(
        title: _titleController.text,
      );
      context
          .read<CreateLearningListBloc>()
          .add(CreateLearningListRequested(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CreateLearningListBloc, CreateLearningListState>(
        listener: (context, state) {
          if (state is CreateLearningListSuccess) {
            Navigator.of(context).pop();
          } else if (state is CreateLearningListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.messages.join('\n')}')),
            );
          }
        },
        builder: (context, state) {
          if (state is CreateLearningListLoading) {
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
                        _createLearningList();
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
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _createLearningList,
                          child: const Text('Create'),
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
