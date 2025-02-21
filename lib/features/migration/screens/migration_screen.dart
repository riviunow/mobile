import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/widgets/loader.dart';

import '../blocs/get_for_migration_bloc.dart';
import '../blocs/migrate_bloc.dart';
import '../models/migrate.dart';
import '../widgets/knowledge_topic_list.dart';
import '../widgets/migration_appbar.dart';

class MigrationScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (_) => const MigrationScreen());
  }

  const MigrationScreen({super.key});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  List<String> selectedKnowledgeIds = [];
  final List<KnowledgeTopic> _breadcrumb = [];
  late GetForMigrationBloc getForMigrationBloc;

  @override
  void initState() {
    super.initState();
    getForMigrationBloc = context.read<GetForMigrationBloc>();
    if (getForMigrationBloc.state is! GetForMigrationLoaded) {
      getForMigrationBloc.add(GetTopicsForMigration());
    }
    context.read<MigrateBloc>().stream.listen((state) {
      if (state is MigrationSuccess) {
        setState(() {
          selectedKnowledgeIds.clear();
        });
      } else if (state is MigrationFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errors.join(', '))),
        );
      }
    });
  }

  void _onKnowledgeSelect(String knowledgeId) {
    setState(() {
      if (selectedKnowledgeIds.contains(knowledgeId)) {
        selectedKnowledgeIds.remove(knowledgeId);
      } else {
        selectedKnowledgeIds.add(knowledgeId);
      }
    });
  }

  void _onMigrate() {
    context.read<MigrateBloc>().add(
        StartMigration(MigrateRequest(knowledgeIds: selectedKnowledgeIds)));
  }

  void _onBack() {
    setState(() {
      if (_breadcrumb.isNotEmpty) {
        _breadcrumb.removeLast();
      }
    });
  }

  void _pushBreadcrumb(KnowledgeTopic topic) {
    setState(() {
      _breadcrumb.add(topic);
    });
  }

  void _onTopicTap(BuildContext context, KnowledgeTopic topic,
      List<String> previousTopicIds) {
    if (topic.children.isNotEmpty &&
        topic.children.every((e) => e.children.isEmpty) &&
        topic.children.every((e) => e.knowledgeTopicKnowledges.isEmpty)) {
      getForMigrationBloc.add(
          GetTopicsForMigration(id: topic.id, previousIds: previousTopicIds));
    }
  }

  KnowledgeTopic? findRecursively(List<KnowledgeTopic> topics, String id) {
    for (var topic in topics) {
      if (topic.id == id) {
        return topic;
      }
      if (topic.children.isNotEmpty) {
        var found = findRecursively(topic.children, id);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MigrationAppBar(
        breadcrumb: _breadcrumb,
        selectedKnowledgeIds: selectedKnowledgeIds,
        onBack: _onBack,
        onMigrate: _onMigrate,
      ),
      body: Stack(
        children: [
          BlocBuilder<GetForMigrationBloc, GetForMigrationState>(
            builder: (context, state) {
              if (getForMigrationBloc.isLoading) {
                return const Loading();
              } else if (state is GetForMigrationLoaded) {
                List<KnowledgeTopic> knowledgeTopics = _breadcrumb.isEmpty
                    ? state.topics
                    : findRecursively(state.topics, _breadcrumb.last.id)
                            ?.children ??
                        [];

                return KnowledgeTopicList(
                  knowledgeTopics: knowledgeTopics,
                  selectedKnowledgeIds: selectedKnowledgeIds,
                  onKnowledgeSelect: _onKnowledgeSelect,
                  onTopicTap: (topic) {
                    var previousTopicIds =
                        _breadcrumb.map((e) => e.id).toList();
                    _pushBreadcrumb(topic);
                    _onTopicTap(context, topic, previousTopicIds);
                  },
                );
              } else if (getForMigrationBloc.errorMessages.isNotEmpty) {
                return Center(
                    child: Text(getForMigrationBloc.errorMessages.join(', ')));
              }
              return Container();
            },
          ),
          if (selectedKnowledgeIds.isNotEmpty)
            Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: _onMigrate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    backgroundColor: AppColors.secondary,
                  ),
                  child: BlocBuilder<MigrateBloc, MigrateState>(
                    builder: (context, state) {
                      if (state is MigrationInProgress) {
                        return const LoadingSmall(
                          loaderType: LoaderType.wave,
                        );
                      }
                      return Text(
                        "${"migrate".tr()} (${selectedKnowledgeIds.length})",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      );
                    },
                  ),
                )),
        ],
      ),
    );
  }
}
