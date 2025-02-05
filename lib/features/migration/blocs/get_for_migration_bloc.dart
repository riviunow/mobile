import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/shared/models/index.dart';

import '../models/get_for_migration.dart';
import '../services/knowledge_topic_service.dart';

abstract class GetForMigrationEvent {}

class GetTopicsForMigration extends GetForMigrationEvent {
  final String? id;
  final List<String> previousIds;

  GetTopicsForMigration({this.id, this.previousIds = const []});
}

class KnowledgesMigrated extends GetForMigrationEvent {
  final List<Learning> learnings;

  KnowledgesMigrated(this.learnings);
}

abstract class GetForMigrationState {}

class GetForMigrationInitial extends GetForMigrationState {}

class GetForMigrationLoaded extends GetForMigrationState {
  final List<KnowledgeTopic> topics;

  GetForMigrationLoaded(this.topics);
}

class GetForMigrationBloc
    extends Bloc<GetForMigrationEvent, GetForMigrationState> {
  final KnowledgeTopicService knowledgeTopicService;
  List<String> errorMessages = [];
  bool isLoading = false;

  GetForMigrationBloc(this.knowledgeTopicService)
      : super(GetForMigrationInitial()) {
    List<KnowledgeTopic> updateTopicsRecursively(List<KnowledgeTopic> topics,
        List<String> previousIds, List<KnowledgeTopic> newChildren) {
      if (previousIds.isEmpty) return topics;

      return topics.map((topic) {
        if (topic.id == previousIds.first) {
          if (previousIds.length == 1) {
            return topic.copyWith(
              children: newChildren,
            );
          } else {
            return topic.copyWith(
              children: updateTopicsRecursively(
                topic.children,
                previousIds.sublist(1),
                newChildren,
              ),
            );
          }
        }
        return topic;
      }).toList();
    }

    on<GetTopicsForMigration>((event, emit) async {
      isLoading = true;
      final response =
          await knowledgeTopicService.getKnowledgeTopicsForMigration(
        GetForMigrationRequest(parentId: event.id),
      );
      await response.on(
          onFailure: (errors, _) => errorMessages = errors,
          onSuccess: (data) {
            errorMessages = [];
            List<KnowledgeTopic> topics = data;
            if (state is GetForMigrationLoaded && event.id != null) {
              final currentState = state as GetForMigrationLoaded;

              topics = updateTopicsRecursively(
                currentState.topics,
                [...event.previousIds, event.id!].toList(),
                data,
              );
            }
            emit(GetForMigrationLoaded(topics));
          });
      isLoading = false;
    });

    KnowledgeTopic updateLearningsRecursively(
        KnowledgeTopic topic, List<Learning> learnings) {
      var updatedKtks = topic.knowledgeTopicKnowledges.map((ktk) {
        if (learnings.any((l) => l.knowledgeId == ktk.knowledgeId)) {
          var learning =
              learnings.firstWhere((l) => l.knowledgeId == ktk.knowledgeId);
          learnings.removeWhere((l) => l.knowledgeId == ktk.knowledgeId);
          return ktk.copyWith(
            knowledge: ktk.knowledge?.copyWith(
              currentUserLearning: learning,
            ),
          );
        }
        return ktk;
      }).toList();

      return topic.copyWith(
        children: topic.children
            .map((child) => updateLearningsRecursively(child, learnings))
            .toList(),
        knowledgeTopicKnowledges: updatedKtks,
      );
    }

    on<KnowledgesMigrated>((event, emit) async {
      List<Learning> learnings = event.learnings;
      if (state is GetForMigrationLoaded) {
        var updatedTopics = (state as GetForMigrationLoaded)
            .topics
            .map((topic) => updateLearningsRecursively(topic, learnings))
            .toList();

        emit(GetForMigrationLoaded(updatedTopics));
      }
    });
  }
}
