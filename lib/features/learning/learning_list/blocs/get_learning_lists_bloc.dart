import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learning_list/services/learning_list_service.dart';
import 'package:rvnow/shared/models/index.dart';

abstract class GetLearningListsEvent {}

class GetLearningListsRequested extends GetLearningListsEvent {
  final List<LearningList>? learningLists;

  GetLearningListsRequested({this.learningLists = const []});
}

abstract class GetLearningListsState {}

class GetLearningListsInitial extends GetLearningListsState {}

class GetLearningListsLoading extends GetLearningListsState {}

class GetLearningListsSuccess extends GetLearningListsState {
  final List<LearningList> learningLists;

  GetLearningListsSuccess(this.learningLists);
}

class GetLearningListsError extends GetLearningListsState {
  final List<String> messages;

  GetLearningListsError({this.messages = const []});
}

class GetLearningListsBloc
    extends Bloc<GetLearningListsEvent, GetLearningListsState> {
  final LearningListService _learningListService;

  GetLearningListsBloc(this._learningListService)
      : super(GetLearningListsInitial()) {
    on<GetLearningListsRequested>((event, emit) async {
      emit(GetLearningListsLoading());

      if (event.learningLists != null) {
        emit(GetLearningListsSuccess(
            event.learningLists!.whereType<LearningList>().toList()));
        return;
      }

      var response = await _learningListService.getLearningLists();
      await response.on(onFailure: (errors, _) {
        emit(GetLearningListsError(messages: errors));
      }, onSuccess: (learningLists) {
        emit(GetLearningListsSuccess(learningLists));
      });
    });
  }
}
