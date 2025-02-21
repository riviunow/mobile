import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/knowledge_service.dart';
import 'created_knowledges_bloc.dart';

abstract class DeleteKnowledgeEvent {}

class DeleteKnowledge extends DeleteKnowledgeEvent {
  final String id;

  DeleteKnowledge(this.id);
}

abstract class DeleteKnowledgeState {}

class DeleteKnowledgeInitial extends DeleteKnowledgeState {}

class DeleteKnowledgeLoading extends DeleteKnowledgeState {}

class DeleteKnowledgeSuccess extends DeleteKnowledgeState {}

class DeleteKnowledgeError extends DeleteKnowledgeState {
  final List<String> messages;

  DeleteKnowledgeError({this.messages = const []});
}

class DeleteKnowledgeBloc
    extends Bloc<DeleteKnowledgeEvent, DeleteKnowledgeState> {
  final KnowledgeService _knowledgeService;
  final CreatedKnowledgesBloc _createdKnowledgesBloc;

  DeleteKnowledgeBloc(this._knowledgeService, this._createdKnowledgesBloc)
      : super(DeleteKnowledgeInitial()) {
    on<DeleteKnowledge>((event, emit) async {
      emit(DeleteKnowledgeLoading());
      var response = await _knowledgeService.deleteKnowledge(event.id);
      await response.on(onFailure: (errors, _) {
        emit(DeleteKnowledgeError(messages: errors));
      }, onSuccess: (_) {
        _createdKnowledgesBloc.add(KnowledgeDeleted(event.id));
        emit(DeleteKnowledgeSuccess());
      });
    });
  }
}
