import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learning_list/services/learning_list_service.dart';
import 'package:udetxen/shared/models/index.dart';

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

  GetLearningListByIdBloc(this._learningListService)
      : super(GetLearningListByIdInitial()) {
    on<GetLearningListByIdRequested>((event, emit) async {
      emit(GetLearningListByIdLoading());

      if (event.learningList != null) {
        emit(GetLearningListByIdSuccess(event.learningList!));
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
