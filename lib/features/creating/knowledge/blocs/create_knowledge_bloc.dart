import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/creating/knowledge/models/create.dart';
import 'package:rvnow/shared/models/index.dart';

import '../services/knowledge_service.dart';

// Events
abstract class CreateKnowledgeEvent {}

class CreateKnowledge extends CreateKnowledgeEvent {
  final CreateKnowledgeRequest request;

  CreateKnowledge(this.request);
}

// States
abstract class CreateKnowledgeState {}

class CreateKnowledgeInitial extends CreateKnowledgeState {}

class CreateKnowledgeLoading extends CreateKnowledgeState {}

class CreateKnowledgeSuccess extends CreateKnowledgeState {
  final Knowledge knowledge;

  CreateKnowledgeSuccess(this.knowledge);
}

class CreateKnowledgeError extends CreateKnowledgeState {
  final List<String> messages;

  CreateKnowledgeError({this.messages = const []});
}

// Bloc
class CreateKnowledgeBloc
    extends Bloc<CreateKnowledgeEvent, CreateKnowledgeState> {
  final KnowledgeService _knowledgeService;

  CreateKnowledgeBloc(this._knowledgeService)
      : super(CreateKnowledgeInitial()) {
    on<CreateKnowledge>((event, emit) async {
      emit(CreateKnowledgeLoading());
      var response = await _knowledgeService.createKnowledge(event.request);
      await response.on(onFailure: (errors, _) {
        emit(CreateKnowledgeError(messages: errors));
      }, onSuccess: (knowledge) {
        emit(CreateKnowledgeSuccess(knowledge));
      });
    });
  }
}
