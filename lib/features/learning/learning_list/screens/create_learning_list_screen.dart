import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learning_list/blocs/create_learning_list_bloc.dart';
import 'package:rvnow/shared/widgets/loader.dart';

import '../models/create_learning_list.dart';

class CreateLearningListScreen extends StatefulWidget {
  final List<String> knowledgeIds;

  static route({List<String> knowledgeIds = const []}) {
    return MaterialPageRoute<void>(
      builder: (_) => CreateLearningListScreen(knowledgeIds: knowledgeIds),
    );
  }

  const CreateLearningListScreen({super.key, this.knowledgeIds = const []});

  @override
  State<CreateLearningListScreen> createState() =>
      _CreateLearningListScreenState();
}

class _CreateLearningListScreenState extends State<CreateLearningListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _createLearningList() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = CreateLearningListRequest(
        title: _titleController.text,
        knowledgeIds: widget.knowledgeIds.isEmpty ? null : widget.knowledgeIds,
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
            Navigator.of(context).pop(true);
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
                      focusNode: _titleFocusNode,
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
                    if (widget.knowledgeIds.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        '(${widget.knowledgeIds.length})  ${"will_be_add_to_list".tr()}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
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
                          onPressed: _createLearningList,
                          child: Text('create'.tr()),
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
