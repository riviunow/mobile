import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learning_list/services/learning_list_service.dart';
import '../models/create_learning_list.dart';
import 'package:rvnow/shared/models/index.dart';

import 'get_learning_lists_bloc.dart';

abstract class CreateLearningListEvent {}

class CreateLearningListRequested extends CreateLearningListEvent {
  final CreateLearningListRequest request;

  CreateLearningListRequested(this.request);
}

abstract class CreateLearningListState {}

class CreateLearningListInitial extends CreateLearningListState {}

class CreateLearningListLoading extends CreateLearningListState {}

class CreateLearningListSuccess extends CreateLearningListState {
  final LearningList learningList;

  CreateLearningListSuccess(this.learningList);
}

class CreateLearningListError extends CreateLearningListState {
  final List<String> messages;

  CreateLearningListError({this.messages = const []});
}

class CreateLearningListBloc
    extends Bloc<CreateLearningListEvent, CreateLearningListState> {
  final LearningListService _learningListService;
  final GetLearningListsBloc getLearningListsBloc;

  CreateLearningListBloc(this._learningListService, this.getLearningListsBloc)
      : super(CreateLearningListInitial()) {
    on<CreateLearningListRequested>((event, emit) async {
      emit(CreateLearningListLoading());
      var response = await _learningListService.create(event.request);
      await response.on(onFailure: (errors, _) {
        emit(CreateLearningListError(messages: errors));
      }, onSuccess: (learningList) {
        if (getLearningListsBloc.state is GetLearningListsSuccess) {
          var state = getLearningListsBloc.state as GetLearningListsSuccess;
          getLearningListsBloc.add(GetLearningListsRequested(
              learningLists: [learningList, ...state.learningLists]));
        }
        emit(CreateLearningListSuccess(learningList));
      });
    });
  }
}
