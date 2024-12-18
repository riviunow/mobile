import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/shared/models/index.dart';
import '../blocs/subject_bloc.dart';
import '../widgets/knowledge_list.dart';

class SubjectDetailScreen extends StatefulWidget {
  final Subject subject;

  static route({required Subject subject}) {
    return MaterialPageRoute<void>(
      builder: (_) => SubjectDetailScreen(subject: subject),
    );
  }

  const SubjectDetailScreen({super.key, required this.subject});

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SubjectBloc>().add(GetSubjectById(widget.subject.id));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.subject.photo),
              const SizedBox(height: 16),
              Text(
                widget.subject.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.subject.description),
              const SizedBox(height: 16),
              BlocBuilder<SubjectBloc, SubjectState>(
                builder: (context, state) {
                  if (state is SubjectLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SubjectLoaded) {
                    return KnowledgeList(
                        knowledges: state.subject.subjectKnowledges
                            .map((sk) => sk.knowledge)
                            .whereType<Knowledge>()
                            .toList());
                  } else if (state is SubjectError) {
                    return Center(
                        child: Text('Error: ${state.messages.join('\n')}'));
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        if (true)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                // TODO
              },
              child: const Text('Learn this Subject'),
            ),
          ),
      ],
    );
  }
}
