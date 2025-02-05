import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/creating/knowledge/blocs/created_knowledges_bloc.dart';
import 'package:rvnow/features/creating/publication_request/services/publication_request_service.dart';

import 'get_publication_requests_bloc.dart';

// Events
abstract class DeletePublicationRequestEvent {}

class DeletePublicationRequest extends DeletePublicationRequestEvent {
  final String requestId;

  DeletePublicationRequest(this.requestId);
}

// States
abstract class DeletePublicationRequestState {}

class DeletePublicationRequestInitial extends DeletePublicationRequestState {}

class DeletePublicationRequestLoading extends DeletePublicationRequestState {}

class DeletePublicationRequestSuccess extends DeletePublicationRequestState {
  final String requestId;

  DeletePublicationRequestSuccess(this.requestId);
}

class DeletePublicationRequestError extends DeletePublicationRequestState {
  final List<String> messages;

  DeletePublicationRequestError({this.messages = const []});
}

// Bloc
class DeletePublicationRequestBloc
    extends Bloc<DeletePublicationRequestEvent, DeletePublicationRequestState> {
  final PublicationRequestService _publicationRequestService;
  final CreatedKnowledgesBloc _createdKnowledgesBloc;
  final GetPublicationRequestsBloc _getPublicationRequestsBloc;

  DeletePublicationRequestBloc(this._publicationRequestService,
      this._createdKnowledgesBloc, this._getPublicationRequestsBloc)
      : super(DeletePublicationRequestInitial()) {
    on<DeletePublicationRequest>((event, emit) async {
      emit(DeletePublicationRequestLoading());
      var response =
          await _publicationRequestService.deleteRequest(event.requestId);
      await response.on(onFailure: (errors, _) {
        emit(DeletePublicationRequestError(messages: errors));
      }, onSuccess: (publicationRequest) {
        _getPublicationRequestsBloc
            .add(PublicationRequestDeleted(event.requestId));
        _createdKnowledgesBloc.add(PublicationDeleted(publicationRequest));
        emit(DeletePublicationRequestSuccess(event.requestId));
      });
    });
  }
}
