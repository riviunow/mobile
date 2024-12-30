import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/creating/publication_request/models/get_requests.dart';
import 'package:udetxen/features/creating/publication_request/services/publication_request_service.dart';
import 'package:udetxen/shared/models/index.dart';

// Events
abstract class GetPublicationRequestsEvent {}

class GetPublicationRequestsRequested extends GetPublicationRequestsEvent {
  final GetPublicationRequests request;

  GetPublicationRequestsRequested(this.request);
}

class LoadMorePublicationRequests extends GetPublicationRequestsEvent {
  final GetPublicationRequests request;

  LoadMorePublicationRequests(this.request);
}

class PublicationRequestDeleted extends GetPublicationRequestsEvent {
  final String requestId;

  PublicationRequestDeleted(this.requestId);
}

class PublicationRequestCreated extends GetPublicationRequestsEvent {
  final PublicationRequest request;

  PublicationRequestCreated(this.request);
}

// States
abstract class GetPublicationRequestsState {}

class GetPublicationRequestsInitial extends GetPublicationRequestsState {}

class GetPublicationRequestsLoading extends GetPublicationRequestsState {}

class GetPublicationRequestsLoaded extends GetPublicationRequestsState {
  final List<PublicationRequest> publicationRequests;
  final bool hasNext;

  GetPublicationRequestsLoaded(this.publicationRequests, this.hasNext);
}

class GetPublicationRequestsError extends GetPublicationRequestsState {
  final List<String> messages;

  GetPublicationRequestsError({this.messages = const []});
}

// Bloc
class GetPublicationRequestsBloc
    extends Bloc<GetPublicationRequestsEvent, GetPublicationRequestsState> {
  final PublicationRequestService _publicationRequestService;

  GetPublicationRequestsBloc(this._publicationRequestService)
      : super(GetPublicationRequestsInitial()) {
    on<GetPublicationRequestsRequested>((event, emit) async {
      emit(GetPublicationRequestsLoading());
      var response = await _publicationRequestService
          .getPublicationRequests(event.request);
      await response.on(onFailure: (errors, _) {
        emit(GetPublicationRequestsError(messages: errors));
      }, onSuccess: (page) {
        emit(GetPublicationRequestsLoaded(page.data, page.hasNext));
      });
    });

    on<LoadMorePublicationRequests>((event, emit) async {
      if (state is GetPublicationRequestsLoaded) {
        var currentState = state as GetPublicationRequestsLoaded;
        var response = await _publicationRequestService
            .getPublicationRequests(event.request);
        await response.on(onFailure: (errors, _) {
          emit(GetPublicationRequestsError(messages: errors));
        }, onSuccess: (page) {
          emit(GetPublicationRequestsLoaded(
            currentState.publicationRequests + page.data,
            page.hasNext,
          ));
        });
      }
    });

    on<PublicationRequestDeleted>((event, emit) {
      if (state is GetPublicationRequestsLoaded) {
        var currentState = state as GetPublicationRequestsLoaded;
        var updatedRequests = currentState.publicationRequests
            .where((request) => request.id != event.requestId)
            .toList();
        emit(GetPublicationRequestsLoaded(
            updatedRequests, currentState.hasNext));
      }
    });

    on<PublicationRequestCreated>((event, emit) {
      if (state is GetPublicationRequestsLoaded) {
        var currentState = state as GetPublicationRequestsLoaded;
        emit(GetPublicationRequestsLoaded(
            [event.request, ...currentState.publicationRequests],
            currentState.hasNext));
      }
    });
  }
}
