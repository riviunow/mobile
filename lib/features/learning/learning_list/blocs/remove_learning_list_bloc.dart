import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learning_list/blocs/get_learning_lists_bloc.dart';
import 'package:udetxen/features/learning/learning_list/services/learning_list_service.dart';
import 'package:udetxen/shared/models/index.dart';

// Events
abstract class RemoveLearningListEvent {}

class RemoveLearningListRequested extends RemoveLearningListEvent {
  final String id;

  RemoveLearningListRequested(this.id);
}

// States
abstract class RemoveLearningListState {}

class RemoveLearningListInitial extends RemoveLearningListState {}

class RemoveLearningListLoading extends RemoveLearningListState {}

class RemoveLearningListSuccess extends RemoveLearningListState {
  final LearningList learningList;

  RemoveLearningListSuccess({required this.learningList});
}

class RemoveLearningListError extends RemoveLearningListState {
  final List<String> messages;

  RemoveLearningListError({this.messages = const []});
}

// Bloc
class RemoveLearningListBloc
    extends Bloc<RemoveLearningListEvent, RemoveLearningListState> {
  final LearningListService _learningListService;
  final GetLearningListsBloc getLearningListsBloc;

  RemoveLearningListBloc(this._learningListService, this.getLearningListsBloc)
      : super(RemoveLearningListInitial()) {
    on<RemoveLearningListRequested>((event, emit) async {
      emit(RemoveLearningListLoading());
      var response = await _learningListService.remove(event.id);
      await response.on(onFailure: (errors, _) {
        emit(RemoveLearningListError(messages: errors));
      }, onSuccess: (data) {
        if (getLearningListsBloc.state is GetLearningListsSuccess) {
          var state = getLearningListsBloc.state as GetLearningListsSuccess;
          getLearningListsBloc.add(GetLearningListsRequested(
              learningLists: state.learningLists
                  .where((element) => element.id != data.id)
                  .toList()));
        }
        emit(RemoveLearningListSuccess(learningList: data));
      });
    });
  }
}
