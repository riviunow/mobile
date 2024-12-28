import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learn_and_review/screens/learn_knowledge_screen.dart';
import 'package:udetxen/shared/constants/urls.dart';
import 'package:udetxen/shared/models/index.dart';
import '../blocs/subject_bloc.dart';
import '../widgets/knowledge_list.dart';

class SubjectDetailScreen extends StatefulWidget {
  final String trackName;
  final Subject subject;
  final bool learnAllKnowledge;

  static route(
      {required Subject subject,
      bool learnAllKnowledge = false,
      required String trackName}) {
    return MaterialPageRoute<void>(
      builder: (_) => SubjectDetailScreen(
          subject: subject,
          learnAllKnowledge: learnAllKnowledge,
          trackName: trackName),
    );
  }

  const SubjectDetailScreen(
      {super.key,
      required this.subject,
      this.learnAllKnowledge = false,
      required this.trackName});

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SubjectBloc>().add(GetSubjectById(widget.subject.id));
  }

  Future<void> _navigateToLearnKnowledgeScreen(
      List<String> knowledgeIds) async {
    var result = await Navigator.push(
      context,
      LearnKnowledgeScreen.route(
          knowledgeIds: knowledgeIds, newLearningListTitle: widget.trackName),
    );
    if (result == true) {
      Navigator.of(context).pop(result);
    } else {
      context.read<SubjectBloc>().add(GetSubjectById(widget.subject.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.subject.photo.isNotEmpty)
                    Image.network("${Urls.mediaUrl}/${widget.subject.photo}"),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      widget.subject.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.subject.description),
                  const SizedBox(height: 16),
                  BlocBuilder<SubjectBloc, SubjectState>(
                    builder: (context, state) {
                      if (state is SubjectLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SubjectLoaded) {
                        if (widget.learnAllKnowledge) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            await _navigateToLearnKnowledgeScreen(
                              state.subject.subjectKnowledges
                                  .map((sk) => sk.knowledge!.id)
                                  .toList(),
                            );
                          });
                        }
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
              top: 8,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            if (!widget.learnAllKnowledge)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: BlocBuilder<SubjectBloc, SubjectState>(
                  builder: (context, state) {
                    if (state is SubjectLoaded) {
                      return ElevatedButton(
                        onPressed: () async =>
                            await _navigateToLearnKnowledgeScreen(
                          state.subject.subjectKnowledges
                              .map((sk) => sk.knowledge!.id)
                              .toList(),
                        ),
                        child: const Text('Learn this Subject'),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
