import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/creating/knowledge/blocs/update_knowledge_bloc.dart';
import 'package:rvnow/features/creating/knowledge/models/update.dart';
import 'package:rvnow/shared/models/enums/knowledge_level.dart';
import 'package:rvnow/shared/models/index.dart';

class UpdateKnowledgeScreen extends StatefulWidget {
  final Knowledge knowledge;

  const UpdateKnowledgeScreen({super.key, required this.knowledge});

  static route(Knowledge knowledge) {
    return MaterialPageRoute<void>(builder: (_) {
      return UpdateKnowledgeScreen(knowledge: knowledge);
    });
  }

  @override
  State<UpdateKnowledgeScreen> createState() => _UpdateKnowledgeScreenState();
}

class _UpdateKnowledgeScreenState extends State<UpdateKnowledgeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late KnowledgeLevel _selectedLevel;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.knowledge.title);
    _selectedLevel = widget.knowledge.level;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = UpdateKnowledgeRequest(
        id: widget.knowledge.id,
        title: _titleController.text,
        level: _selectedLevel,
      );
      context.read<UpdateKnowledgeBloc>().add(UpdateKnowledge(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('update_knowledge'.tr()),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocListener<UpdateKnowledgeBloc, UpdateKnowledgeState>(
        listener: (context, state) {
          if (state is UpdateKnowledgeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('knowledge_updated_successfully'.tr())),
            );
            Navigator.pop(context);
          } else if (state is UpdateKnowledgeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.messages.join(', '))),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<KnowledgeLevel>(
                  value: _selectedLevel,
                  decoration: const InputDecoration(labelText: 'Level'),
                  items: KnowledgeLevel.values.map((KnowledgeLevel level) {
                    return DropdownMenuItem<KnowledgeLevel>(
                      value: level,
                      child: Text(level.toStr()),
                    );
                  }).toList(),
                  onChanged: (KnowledgeLevel? newValue) {
                    setState(() {
                      _selectedLevel = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text('update'.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
