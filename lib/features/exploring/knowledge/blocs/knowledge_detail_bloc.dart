import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/shared/models/index.dart';
import '../services/knowledge_service.dart';

abstract class KnowledgeDetailEvent {}

class GetKnowledgeDetail extends KnowledgeDetailEvent {
  final String id;

  GetKnowledgeDetail(this.id);
}

abstract class KnowledgeDetailState {}

class KnowledgeDetailInitial extends KnowledgeDetailState {}

class KnowledgeDetailLoading extends KnowledgeDetailState {}

class KnowledgeDetailLoaded extends KnowledgeDetailState {
  final Knowledge knowledge;

  KnowledgeDetailLoaded(this.knowledge);
}

class KnowledgeDetailError extends KnowledgeDetailState {
  final List<String> messages;

  KnowledgeDetailError({this.messages = const []});
}

class KnowledgeDetailBloc
    extends Bloc<KnowledgeDetailEvent, KnowledgeDetailState> {
  final KnowledgeService _knowledgeService;

  KnowledgeDetailBloc(this._knowledgeService)
      : super(KnowledgeDetailInitial()) {
    on<GetKnowledgeDetail>((event, emit) async {
      emit(KnowledgeDetailLoading());
      var response = await _knowledgeService.getKnowledge(event.id);
      await response.on(onFailure: (errors, _) {
        emit(KnowledgeDetailError(messages: errors));
      }, onSuccess: (knowledge) {
        emit(KnowledgeDetailLoaded(knowledge));
      });
    });
  }
}
