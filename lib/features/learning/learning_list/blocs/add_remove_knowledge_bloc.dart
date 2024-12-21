import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learning_list/services/learning_list_service.dart';
import 'package:udetxen/shared/models/index.dart';
import '../models/add_remove_knowledge.dart';
import 'get_learning_list_by_id_bloc.dart';

// Events
abstract class AddRemoveKnowledgeEvent {}

class AddRemoveKnowledgeRequested extends AddRemoveKnowledgeEvent {
  final AddRemoveKnowledgeRequest request;

  AddRemoveKnowledgeRequested(this.request);
}

// States
abstract class AddRemoveKnowledgeState {}

class AddRemoveKnowledgeInitial extends AddRemoveKnowledgeState {}

class AddRemoveKnowledgeLoading extends AddRemoveKnowledgeState {}

class AddRemoveKnowledgeSuccess extends AddRemoveKnowledgeState {
  final LearningListKnowledge learningListKnowledge;

  AddRemoveKnowledgeSuccess(this.learningListKnowledge);
}

class AddRemoveKnowledgeError extends AddRemoveKnowledgeState {
  final List<String> messages;

  AddRemoveKnowledgeError({this.messages = const []});
}

// Bloc
class AddRemoveKnowledgeBloc
    extends Bloc<AddRemoveKnowledgeEvent, AddRemoveKnowledgeState> {
  final LearningListService _learningListService;
  final GetLearningListByIdBloc _getLearningListByIdBloc;

  AddRemoveKnowledgeBloc(
      this._learningListService, this._getLearningListByIdBloc)
      : super(AddRemoveKnowledgeInitial()) {
    on<AddRemoveKnowledgeRequested>((event, emit) async {
      emit(AddRemoveKnowledgeLoading());
      var response =
          await _learningListService.addRemoveKnowledge(event.request);
      await response.on(onFailure: (errors, _) {
        emit(AddRemoveKnowledgeError(messages: errors));
      }, onSuccess: (llk) {
        emit(AddRemoveKnowledgeSuccess(llk));

        if (_getLearningListByIdBloc.state is GetLearningListByIdSuccess) {
          var state =
              _getLearningListByIdBloc.state as GetLearningListByIdSuccess;
          if (state.learningList.id != llk.learningListId) {
            return;
          }
          LearningList updatedLearningList;
          if (llk.deleted) {
            updatedLearningList = state.learningList.copyWith(
              learntKnowledges: state.learningList.learntKnowledges
                  .where((knowledge) => knowledge.id != llk.knowledgeId)
                  .toList(),
              notLearntKnowledges: state.learningList.notLearntKnowledges
                  .where((knowledge) => knowledge.id != llk.knowledgeId)
                  .toList(),
            );
          } else {
            if (llk.knowledge?.currentUserLearning != null) {
              updatedLearningList = state.learningList.copyWith(
                learntKnowledges: [
                  llk.knowledge!.currentUserLearning!,
                  ...state.learningList.learntKnowledges,
                ],
              );
            } else {
              updatedLearningList =
                  state.learningList.copyWith(notLearntKnowledges: [
                llk.knowledge!,
                ...state.learningList.notLearntKnowledges,
              ]);
            }
          }
          _getLearningListByIdBloc.add(
            GetLearningListByIdRequested(
              state.learningList.id,
              learningList: updatedLearningList,
            ),
          );
        }
      });
    });
  }
}
