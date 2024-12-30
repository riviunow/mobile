import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/creating/knowledge/blocs/created_knowledges_bloc.dart';
import 'package:udetxen/features/creating/publication_request/models/publish_knowledge.dart';
import 'package:udetxen/features/creating/publication_request/services/publication_request_service.dart';
import 'package:udetxen/shared/models/index.dart';

import 'get_publication_requests_bloc.dart';

// Events
abstract class PublishKnowledgeEvent {}

class PublishKnowledgeRequested extends PublishKnowledgeEvent {
  final PublishKnowledgeRequest request;

  PublishKnowledgeRequested(this.request);
}

// States
abstract class PublishKnowledgeState {}

class PublishKnowledgeInitial extends PublishKnowledgeState {}

class PublishKnowledgeLoading extends PublishKnowledgeState {}

class PublishKnowledgeSuccess extends PublishKnowledgeState {
  final PublicationRequest publicationRequest;

  PublishKnowledgeSuccess(this.publicationRequest);
}

class PublishKnowledgeError extends PublishKnowledgeState {
  final List<String> messages;

  PublishKnowledgeError({this.messages = const []});
}

// Bloc
class PublishKnowledgeBloc
    extends Bloc<PublishKnowledgeEvent, PublishKnowledgeState> {
  final PublicationRequestService _publicationRequestService;
  final CreatedKnowledgesBloc _createdKnowledgesBloc;
  final GetPublicationRequestsBloc _getPublicationRequestsBloc;

  PublishKnowledgeBloc(this._publicationRequestService,
      this._createdKnowledgesBloc, this._getPublicationRequestsBloc)
      : super(PublishKnowledgeInitial()) {
    on<PublishKnowledgeRequested>((event, emit) async {
      emit(PublishKnowledgeLoading());
      var response =
          await _publicationRequestService.publishKnowledge(event.request);
      await response.on(onFailure: (errors, _) {
        emit(PublishKnowledgeError(messages: errors));
      }, onSuccess: (publicationRequest) {
        _getPublicationRequestsBloc
            .add(PublicationRequestCreated(publicationRequest));
        _createdKnowledgesBloc.add(PublicationRequested(publicationRequest));
        emit(PublishKnowledgeSuccess(publicationRequest));
      });
    });
  }
}
