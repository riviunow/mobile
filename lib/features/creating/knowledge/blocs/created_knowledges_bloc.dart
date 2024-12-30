import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/creating/knowledge/models/get_created.dart';
import 'package:udetxen/shared/models/index.dart';
import '../services/knowledge_service.dart';

// Events
abstract class CreatedKnowledgesEvent {}

class GetCreatedKnowledges extends CreatedKnowledgesEvent {
  final GetCreatedKnowledgesRequest request;

  GetCreatedKnowledges(this.request);
}

class LoadMoreCreatedKnowledges extends CreatedKnowledgesEvent {
  final GetCreatedKnowledgesRequest request;

  LoadMoreCreatedKnowledges(this.request);
}

class KnowledgeUpdated extends CreatedKnowledgesEvent {
  final Knowledge updatedKnowledge;

  KnowledgeUpdated(this.updatedKnowledge);
}

class KnowledgeDeleted extends CreatedKnowledgesEvent {
  final String deletedKnowledgeId;

  KnowledgeDeleted(this.deletedKnowledgeId);
}

class PublicationRequested extends CreatedKnowledgesEvent {
  final PublicationRequest request;

  PublicationRequested(this.request);
}

class PublicationDeleted extends CreatedKnowledgesEvent {
  final PublicationRequest request;

  PublicationDeleted(this.request);
}

// States
abstract class CreatedKnowledgesState {}

class CreatedKnowledgesInitial extends CreatedKnowledgesState {}

class CreatedKnowledgesLoading extends CreatedKnowledgesState {}

class CreatedKnowledgesLoaded extends CreatedKnowledgesState {
  final List<Knowledge> knowledges;
  final bool hasNext;

  CreatedKnowledgesLoaded(this.knowledges, this.hasNext);
}

class CreatedKnowledgesError extends CreatedKnowledgesState {
  final List<String> messages;

  CreatedKnowledgesError({this.messages = const []});
}

// Bloc
class CreatedKnowledgesBloc
    extends Bloc<CreatedKnowledgesEvent, CreatedKnowledgesState> {
  final KnowledgeService _knowledgeService;

  CreatedKnowledgesBloc(this._knowledgeService)
      : super(CreatedKnowledgesInitial()) {
    on<GetCreatedKnowledges>((event, emit) async {
      emit(CreatedKnowledgesLoading());
      var response =
          await _knowledgeService.getCreatedKnowledges(event.request);
      await response.on(onFailure: (errors, _) {
        emit(CreatedKnowledgesError(messages: errors));
      }, onSuccess: (page) {
        emit(CreatedKnowledgesLoaded(page.data, page.hasNext));
      });
    });

    on<LoadMoreCreatedKnowledges>((event, emit) async {
      if (state is CreatedKnowledgesLoaded) {
        var currentState = state as CreatedKnowledgesLoaded;
        var response =
            await _knowledgeService.getCreatedKnowledges(event.request);
        await response.on(onFailure: (errors, _) {
          emit(CreatedKnowledgesError(messages: errors));
        }, onSuccess: (page) {
          emit(CreatedKnowledgesLoaded(
            currentState.knowledges + page.data,
            page.hasNext,
          ));
        });
      }
    });

    on<KnowledgeUpdated>((event, emit) {
      if (state is CreatedKnowledgesLoaded) {
        var currentState = state as CreatedKnowledgesLoaded;
        var updatedKnowledges = currentState.knowledges.map((knowledge) {
          return knowledge.id == event.updatedKnowledge.id
              ? event.updatedKnowledge
              : knowledge;
        }).toList();
        emit(CreatedKnowledgesLoaded(updatedKnowledges, currentState.hasNext));
      }
    });

    on<KnowledgeDeleted>((event, emit) {
      if (state is CreatedKnowledgesLoaded) {
        var currentState = state as CreatedKnowledgesLoaded;
        var updatedKnowledges = currentState.knowledges
            .where((knowledge) => knowledge.id != event.deletedKnowledgeId)
            .toList();
        emit(CreatedKnowledgesLoaded(updatedKnowledges, currentState.hasNext));
      }
    });

    on<PublicationRequested>((event, emit) async {
      if (state is CreatedKnowledgesLoaded) {
        var currentState = state as CreatedKnowledgesLoaded;
        var updatedKnowledges = currentState.knowledges.map((knowledge) {
          return knowledge.id == event.request.knowledgeId
              ? knowledge.copyWith(publicationRequest: event.request)
              : knowledge;
        }).toList();
        emit(CreatedKnowledgesLoaded(updatedKnowledges, currentState.hasNext));
      }
    });

    on<PublicationDeleted>((event, emit) async {
      if (state is CreatedKnowledgesLoaded) {
        var currentState = state as CreatedKnowledgesLoaded;
        var updatedKnowledges = currentState.knowledges.map((knowledge) {
          return knowledge.id == event.request.knowledgeId
              ? knowledge.copyWith(
                  publicationRequest: null as PublicationRequest?)
              : knowledge;
        }).toList();
        emit(CreatedKnowledgesLoaded(updatedKnowledges, currentState.hasNext));
      }
    });
  }
}
