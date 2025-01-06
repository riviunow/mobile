import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/knowledge_learning/blocs/unlisted_learnings_bloc.dart';
import 'package:udetxen/features/learning/learning_list/services/learning_list_service.dart';
import 'package:udetxen/shared/models/index.dart';
import '../models/add_remove_knowledges.dart';
import 'get_learning_list_by_id_bloc.dart';
// import 'get_learning_lists_bloc.dart';

// Events
abstract class AddRemoveKnowledgesEvent {}

class AddRemoveKnowledgesRequested extends AddRemoveKnowledgesEvent {
  final AddRemoveKnowledgesRequest request;

  AddRemoveKnowledgesRequested(this.request);
}

// States
abstract class AddRemoveKnowledgesState {}

class AddRemoveKnowledgesInitial extends AddRemoveKnowledgesState {}

class AddRemoveKnowledgesLoading extends AddRemoveKnowledgesState {}

class AddRemoveKnowledgesSuccess extends AddRemoveKnowledgesState {
  final List<LearningListKnowledge> learningListKnowledge;

  AddRemoveKnowledgesSuccess(this.learningListKnowledge);
}

class AddRemoveKnowledgesError extends AddRemoveKnowledgesState {
  final List<String> messages;

  AddRemoveKnowledgesError({this.messages = const []});
}

// Bloc
class AddRemoveKnowledgesBloc
    extends Bloc<AddRemoveKnowledgesEvent, AddRemoveKnowledgesState> {
  final LearningListService _learningListService;
  final GetLearningListByIdBloc _getLearningListByIdBloc;
  // final GetLearningListsBloc _getLearningListsBloc;
  final UnlistedLearningsBloc _unlistedLearningsBloc;

  AddRemoveKnowledgesBloc(this._learningListService,
      this._getLearningListByIdBloc, this._unlistedLearningsBloc)
      : super(AddRemoveKnowledgesInitial()) {
    on<AddRemoveKnowledgesRequested>((event, emit) async {
      emit(AddRemoveKnowledgesLoading());
      var response =
          await _learningListService.addRemoveKnowledges(event.request);
      await response.on(onFailure: (errors, _) {
        emit(AddRemoveKnowledgesError(messages: errors));
      }, onSuccess: (llks) {
        emit(AddRemoveKnowledgesSuccess(llks));
        if (_getLearningListByIdBloc.state is GetLearningListByIdSuccess) {
          var state =
              _getLearningListByIdBloc.state as GetLearningListByIdSuccess;
          if (state.learningList.id == event.request.learningListId) {
            LearningList updatedLearningList = event.request.isAdd
                ? state.learningList.copyWith(learningListKnowledges: [
                    ...llks,
                    ...state.learningList.learningListKnowledges,
                  ])
                : state.learningList.copyWith(
                    learningListKnowledges: state
                        .learningList.learningListKnowledges
                        .where((llk) => llks.every(
                            (newLlk) => newLlk.knowledgeId != llk.knowledgeId))
                        .toList(),
                  );

            _getLearningListByIdBloc.add(
              GetLearningListByIdRequested(
                state.learningList.id,
                learningList: updatedLearningList,
              ),
            );
          }
        }

        if (_unlistedLearningsBloc.state is UnlistedLearningsLoaded) {
          var state = _unlistedLearningsBloc.state as UnlistedLearningsLoaded;
          var learntLlks = llks
              .where((llk) => llk.knowledge?.currentUserLearning != null)
              .toList();
          _unlistedLearningsBloc.add(FetchUnlistedLearnings(
              knowledges: event.request.isAdd
                  ? state.knowledges
                      .where((k) =>
                          learntLlks.every((llk) => llk.knowledgeId != k.id))
                      .toList()
                  : [
                      ...learntLlks.map((llk) => llk.knowledge!),
                      ...state.knowledges
                    ]));
        }
      });
    });
  }
}
