import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/shared/models/index.dart';
import '../models/search_knowledge.dart';
import '../services/knowledge_service.dart';

abstract class KnowledgeEvent {}

class SearchKnowledges extends KnowledgeEvent {
  final SearchKnowledgesRequest request;

  SearchKnowledges(this.request);
}

class LoadMoreKnowledges extends KnowledgeEvent {
  final SearchKnowledgesRequest request;

  LoadMoreKnowledges(this.request);
}

abstract class KnowledgeState {}

class KnowledgeInitial extends KnowledgeState {}

class KnowledgeLoading extends KnowledgeState {}

class KnowledgeLoaded extends KnowledgeState {
  final List<Knowledge> knowledges;
  final bool hasNext;

  KnowledgeLoaded(this.knowledges, this.hasNext);
}

class KnowledgeError extends KnowledgeState {
  final List<String> messages;

  KnowledgeError({this.messages = const []});
}

class KnowledgeBloc extends Bloc<KnowledgeEvent, KnowledgeState> {
  final KnowledgeService _knowledgeService;

  KnowledgeBloc(this._knowledgeService) : super(KnowledgeInitial()) {
    on<SearchKnowledges>((event, emit) async {
      emit(KnowledgeLoading());
      var response = await _knowledgeService.searchKnowledges(event.request);
      await response.on(onFailure: (errors, _) {
        emit(KnowledgeError(messages: errors));
      }, onSuccess: (page) {
        emit(KnowledgeLoaded(page.data, page.hasNext));
      });
    });

    on<LoadMoreKnowledges>((event, emit) async {
      if (state is KnowledgeLoaded) {
        var currentState = state as KnowledgeLoaded;
        var response = await _knowledgeService.searchKnowledges(event.request);
        await response.on(onFailure: (errors, _) {
          emit(KnowledgeError(messages: errors));
        }, onSuccess: (page) {
          emit(KnowledgeLoaded(
            currentState.knowledges + page.data,
            page.hasNext,
          ));
        });
      }
    });
  }
}
