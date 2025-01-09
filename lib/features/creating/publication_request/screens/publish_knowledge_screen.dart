import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/creating/publication_request/blocs/publish_knowledge_bloc.dart';
import 'package:udetxen/features/creating/publication_request/models/publish_knowledge.dart';
import 'package:udetxen/shared/models/index.dart';

class PublishKnowledgeScreen extends StatefulWidget {
  final Knowledge knowledge;

  const PublishKnowledgeScreen({super.key, required this.knowledge});

  static route(Knowledge knowledge) {
    return MaterialPageRoute<void>(builder: (_) {
      return PublishKnowledgeScreen(knowledge: knowledge);
    });
  }

  @override
  State<PublishKnowledgeScreen> createState() => _PublishKnowledgeScreenState();
}

class _PublishKnowledgeScreenState extends State<PublishKnowledgeScreen> {
  void _submit() {
    final request = PublishKnowledgeRequest(knowledgeId: widget.knowledge.id);
    context
        .read<PublishKnowledgeBloc>()
        .add(PublishKnowledgeRequested(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('publish_knowledge'.tr()),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocListener<PublishKnowledgeBloc, PublishKnowledgeState>(
        listener: (context, state) {
          if (state is PublishKnowledgeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('knowledge_published_successfully'.tr())));
            Navigator.pop(context);
          } else if (state is PublishKnowledgeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.messages.join('\n')}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${'are_you_sure_to_publish'.tr()} "${widget.knowledge.title}"?',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('publish'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
