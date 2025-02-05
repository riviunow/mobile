import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/exploring/knowledge/models/knowledge_topic.dart';
import 'package:rvnow/features/exploring/knowledge/services/knowledge_topic_service.dart';
import 'package:rvnow/shared/models/index.dart';

abstract class KnowledgeTopicEvent {}

class GetKnowledgeTopics extends KnowledgeTopicEvent {
  final KnowledgeTopicsRequest request;

  GetKnowledgeTopics(this.request);
}

abstract class KnowledgeTopicState {}

class KnowledgeTopicInitial extends KnowledgeTopicState {}

class KnowledgeTopicLoading extends KnowledgeTopicState {}

class KnowledgeTopicLoaded extends KnowledgeTopicState {
  final List<KnowledgeTopic> knowledgeTopics;

  KnowledgeTopicLoaded(this.knowledgeTopics);
}

class KnowledgeTopicError extends KnowledgeTopicState {
  final List<String> messages;

  KnowledgeTopicError({this.messages = const []});
}

class KnowledgeTopicBloc
    extends Bloc<KnowledgeTopicEvent, KnowledgeTopicState> {
  final KnowledgeTopicService _knowledgeTopicService;

  KnowledgeTopicBloc(this._knowledgeTopicService)
      : super(KnowledgeTopicInitial()) {
    on<GetKnowledgeTopics>((event, emit) async {
      emit(KnowledgeTopicLoading());
      var response =
          await _knowledgeTopicService.getKnowledgeTopics(event.request);
      await response.on(onFailure: (errors, _) {
        emit(KnowledgeTopicError(messages: errors));
      }, onSuccess: (knowledgeTopics) {
        emit(KnowledgeTopicLoaded(knowledgeTopics));
      });
    });
  }
}
