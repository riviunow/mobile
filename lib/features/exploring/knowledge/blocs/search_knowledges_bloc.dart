import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/shared/models/index.dart';
import '../models/search_knowledge.dart';
import '../services/knowledge_service.dart';

abstract class SearchKnowledgesEvent {}

class SearchKnowledges extends SearchKnowledgesEvent {
  final SearchKnowledgesRequest request;

  SearchKnowledges(this.request);
}

class LoadMoreKnowledges extends SearchKnowledgesEvent {
  final SearchKnowledgesRequest request;

  LoadMoreKnowledges(this.request);
}

class SearchKnowledgesLearningUpdated extends SearchKnowledgesEvent {
  final List<Knowledge> knowledges;
  final bool hasNext;

  SearchKnowledgesLearningUpdated(this.knowledges, this.hasNext);
}

abstract class SearchKnowledgesState {}

class KnowledgeInitial extends SearchKnowledgesState {}

class KnowledgeLoading extends SearchKnowledgesState {}

class KnowledgeLoaded extends SearchKnowledgesState {
  final List<Knowledge> knowledges;
  final bool hasNext;

  KnowledgeLoaded(this.knowledges, this.hasNext);
}

class KnowledgeError extends SearchKnowledgesState {
  final List<String> messages;

  KnowledgeError({this.messages = const []});
}

class SearchKnowledgesBloc
    extends Bloc<SearchKnowledgesEvent, SearchKnowledgesState> {
  final KnowledgeService _knowledgeService;

  SearchKnowledgesBloc(this._knowledgeService) : super(KnowledgeInitial()) {
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
          var newKnowledges = (currentState.knowledges + page.data)
              .fold<Map<String, Knowledge>>({}, (map, knowledge) {
                map[knowledge.id] = knowledge;
                return map;
              })
              .values
              .toList();
          emit(KnowledgeLoaded(
            newKnowledges,
            page.hasNext,
          ));
        });
      }
    });

    on<SearchKnowledgesLearningUpdated>((event, emit) => emit(
          KnowledgeLoaded(event.knowledges, event.hasNext),
        ));
  }
}
