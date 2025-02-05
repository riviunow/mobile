import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/creating/knowledge/models/update.dart';
import 'package:rvnow/shared/models/index.dart';
import '../services/knowledge_service.dart';
import 'created_knowledges_bloc.dart';

// Events
abstract class UpdateKnowledgeEvent {}

class UpdateKnowledge extends UpdateKnowledgeEvent {
  final UpdateKnowledgeRequest request;

  UpdateKnowledge(this.request);
}

// States
abstract class UpdateKnowledgeState {}

class UpdateKnowledgeInitial extends UpdateKnowledgeState {}

class UpdateKnowledgeLoading extends UpdateKnowledgeState {}

class UpdateKnowledgeSuccess extends UpdateKnowledgeState {
  final Knowledge knowledge;

  UpdateKnowledgeSuccess(this.knowledge);
}

class UpdateKnowledgeError extends UpdateKnowledgeState {
  final List<String> messages;

  UpdateKnowledgeError({this.messages = const []});
}

// Bloc
class UpdateKnowledgeBloc
    extends Bloc<UpdateKnowledgeEvent, UpdateKnowledgeState> {
  final KnowledgeService _knowledgeService;
  final CreatedKnowledgesBloc _createdKnowledgesBloc;

  UpdateKnowledgeBloc(this._knowledgeService, this._createdKnowledgesBloc)
      : super(UpdateKnowledgeInitial()) {
    on<UpdateKnowledge>((event, emit) async {
      emit(UpdateKnowledgeLoading());
      var response = await _knowledgeService.updateKnowledge(event.request);
      await response.on(onFailure: (errors, _) {
        emit(UpdateKnowledgeError(messages: errors));
      }, onSuccess: (knowledge) {
        _createdKnowledgesBloc.add(KnowledgeUpdated(knowledge));
        emit(UpdateKnowledgeSuccess(knowledge));
      });
    });
  }
}
