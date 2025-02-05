import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learning_list/blocs/get_learning_lists_bloc.dart';
import 'package:rvnow/features/learning/learning_list/services/learning_list_service.dart';
import 'package:rvnow/shared/models/index.dart';

// Events
abstract class GetLearningListByIdEvent {}

class GetLearningListByIdRequested extends GetLearningListByIdEvent {
  final String id;
  final LearningList? learningList;

  GetLearningListByIdRequested(this.id, {this.learningList});
}

// States
abstract class GetLearningListByIdState {}

class GetLearningListByIdInitial extends GetLearningListByIdState {}

class GetLearningListByIdLoading extends GetLearningListByIdState {}

class GetLearningListByIdSuccess extends GetLearningListByIdState {
  final LearningList learningList;

  GetLearningListByIdSuccess(this.learningList);
}

class GetLearningListByIdError extends GetLearningListByIdState {
  final List<String> messages;

  GetLearningListByIdError({this.messages = const []});
}

// Bloc
class GetLearningListByIdBloc
    extends Bloc<GetLearningListByIdEvent, GetLearningListByIdState> {
  final LearningListService _learningListService;
  final GetLearningListsBloc _getLearningListsBloc;
  // TODO

  GetLearningListByIdBloc(this._learningListService, this._getLearningListsBloc)
      : super(GetLearningListByIdInitial()) {
    on<GetLearningListByIdRequested>((event, emit) async {
      emit(GetLearningListByIdLoading());

      if (event.learningList != null) {
        emit(GetLearningListByIdSuccess(event.learningList!));
        if (_getLearningListsBloc.state is GetLearningListsSuccess) {
          var state = _getLearningListsBloc.state as GetLearningListsSuccess;
          _getLearningListsBloc.add(GetLearningListsRequested(
            learningLists: state.learningLists
                .map((e) => e.id == event.learningList!.id
                    ? e.copyWith(
                        title: event.learningList!.title,
                        notLearntKnowledgeCount:
                            event.learningList!.notLearntKnowledges.length,
                        learntKnowledgeCount:
                            event.learningList!.learntKnowledges.length,
                      )
                    : e)
                .toList(),
          ));
        }
        return;
      }

      var response = await _learningListService.getLearningList(event.id);
      await response.on(onFailure: (errors, _) {
        emit(GetLearningListByIdError(messages: errors));
      }, onSuccess: (learningList) {
        emit(GetLearningListByIdSuccess(learningList));
      });
    });
  }
}
