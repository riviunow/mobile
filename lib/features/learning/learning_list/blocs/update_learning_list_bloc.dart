import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learning_list/services/learning_list_service.dart';
import '../models/update_learning_list.dart';
import 'package:rvnow/shared/models/index.dart';

import 'get_learning_list_by_id_bloc.dart';
// import 'get_learning_lists_bloc.dart';

abstract class UpdateLearningListEvent {}

class UpdateLearningListRequested extends UpdateLearningListEvent {
  final UpdateLearningListRequest request;

  UpdateLearningListRequested(this.request);
}

abstract class UpdateLearningListState {}

class UpdateLearningListInitial extends UpdateLearningListState {}

class UpdateLearningListLoading extends UpdateLearningListState {}

class UpdateLearningListSuccess extends UpdateLearningListState {
  final LearningList learningList;

  UpdateLearningListSuccess(this.learningList);
}

class UpdateLearningListError extends UpdateLearningListState {
  final List<String> messages;

  UpdateLearningListError({this.messages = const []});
}

class UpdateLearningListBloc
    extends Bloc<UpdateLearningListEvent, UpdateLearningListState> {
  final LearningListService _learningListService;
  final GetLearningListByIdBloc getLearningListByIdBloc;
  // final GetLearningListsBloc getLearningListsBloc;

  UpdateLearningListBloc(
      this._learningListService, this.getLearningListByIdBloc)
      : super(UpdateLearningListInitial()) {
    on<UpdateLearningListRequested>((event, emit) async {
      emit(UpdateLearningListLoading());
      var response = await _learningListService.update(event.request);
      await response.on(onFailure: (errors, _) {
        emit(UpdateLearningListError(messages: errors));
      }, onSuccess: (learningList) {
        if (getLearningListByIdBloc.state is GetLearningListByIdSuccess) {
          var state =
              getLearningListByIdBloc.state as GetLearningListByIdSuccess;
          getLearningListByIdBloc.add(GetLearningListByIdRequested(
              learningList.id,
              learningList:
                  state.learningList.copyWith(title: learningList.title)));
        }
        emit(UpdateLearningListSuccess(learningList));
      });
    });
  }
}
