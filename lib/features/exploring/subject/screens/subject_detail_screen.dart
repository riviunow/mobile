import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/widgets/knowledge_list.dart';
import 'package:udetxen/features/learning/learn_and_review/screens/learn_knowledge_screen.dart';
import 'package:udetxen/features/learning/learn_and_review/screens/review_knowledge_screen.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/constants/urls.dart';
import 'package:udetxen/shared/models/index.dart';
import '../blocs/subject_bloc.dart';
// import '../widgets/knowledge_list.dart';

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

    var bloc = context.read<SubjectBloc>();
    if (bloc.state is! SubjectLoaded ||
        (bloc.state is SubjectLoaded &&
            (bloc.state as SubjectLoaded).subject.id != widget.subject.id)) {
      bloc.add(GetSubjectById(widget.subject.id));
    }
  }

  Future<void> _navigateToLearnKnowledgeScreen(
      List<String> knowledgeIds) async {
    var result = await Navigator.push(
      context,
      LearnKnowledgeScreen.route(
          knowledgeIds: knowledgeIds, newLearningListTitle: widget.trackName),
    );
    if (result == true && widget.learnAllKnowledge) {
      Navigator.of(context).pop(result);
    }
  }

  Future<void> _navigateToReviewKnowledgeScreen(
      List<String> knowledgeIds) async {
    var result = await Navigator.push(
      context,
      ReviewKnowledgeScreen.route(knowledgeIds: knowledgeIds),
    );
    if (result == true && widget.learnAllKnowledge) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(widget.subject.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.subject.photo.isNotEmpty) ...[
                    Image.network("${Urls.mediaUrl}/${widget.subject.photo}"),
                    const SizedBox(height: 10),
                  ],
                  if (widget.subject.description.isNotEmpty) ...[
                    Text(widget.subject.description),
                    const SizedBox(height: 16),
                  ],
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
                                  .where((sk) =>
                                      sk.knowledge?.currentUserLearning == null)
                                  .map((sk) => sk.knowledge!.id)
                                  .toList(),
                            );
                          });
                        }
                        return Expanded(
                          child: KnowledgeList(
                            knowledges: state.subject.subjectKnowledges
                                .map((sk) => sk.knowledge)
                                .whereType<Knowledge>()
                                .toList(),
                            hasNext: false,
                            onLoadMore: () {},
                            isSelectionMode: false,
                            selectedKnowledgeIds: const <String>{},
                            onKnowledgeSelected: (_) {},
                          ),
                        );
                      } else if (state is SubjectError) {
                        return Center(
                            child: Text('Error: ${state.messages.join('\n')}'));
                      } else {
                        return Center(child: Text('no_data_available'.tr()));
                      }
                    },
                  ),
                  const SizedBox(height: 40)
                ],
              ),
            ),
            if (!widget.learnAllKnowledge) // todo
              Positioned(
                bottom: 6,
                left: 20,
                right: 20,
                child: BlocBuilder<SubjectBloc, SubjectState>(
                  builder: (context, state) {
                    if (state is SubjectLoaded) {
                      final currentUserLearningCount = state
                          .subject.subjectKnowledges
                          .where(
                              (sk) => sk.knowledge?.currentUserLearning != null)
                          .length;
                      final totalKnowledges =
                          state.subject.subjectKnowledges.length;
                      final percentage =
                          currentUserLearningCount / totalKnowledges;

                      String buttonText;
                      if (percentage == 0) {
                        buttonText = 'Start Learning';
                      } else if (percentage < 1) {
                        buttonText =
                            'Continue Learning (${(percentage * 100).toStringAsFixed(0)}%)';
                      } else {
                        buttonText = 'Review Subject';
                      }

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppColors.secondary,
                        ),
                        onPressed: (percentage >= 0 && percentage < 1)
                            ? () async {
                                await _navigateToLearnKnowledgeScreen(state
                                    .subject.subjectKnowledges
                                    .map((sk) => sk.knowledge)
                                    .where(
                                        (k) => k!.currentUserLearning == null)
                                    .map((k) => k!.id)
                                    .toList());
                              }
                            : state.subject.subjectKnowledges
                                    .map((sk) => sk.knowledge)
                                    .where((k) =>
                                        k!.currentUserLearning != null &&
                                        k.currentUserLearning?.isDue == true)
                                    .toList()
                                    .isEmpty
                                ? null
                                : () async {
                                    await _navigateToReviewKnowledgeScreen(state
                                        .subject.subjectKnowledges
                                        .map((sk) => sk.knowledge)
                                        .where((k) =>
                                            k!.currentUserLearning != null &&
                                            k.currentUserLearning?.isDue ==
                                                true)
                                        .map((k) => k!.id)
                                        .toList());
                                  },
                        child: Text(buttonText,
                            style: const TextStyle(fontSize: 18)),
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
