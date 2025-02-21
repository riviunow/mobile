import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/knowledge_learning/blocs/current_user_learnings_bloc.dart';
import 'package:rvnow/features/learning/knowledge_learning/blocs/unlisted_learnings_bloc.dart';
import 'package:rvnow/features/learning/learning_list/blocs/get_learning_list_by_id_bloc.dart';
import 'package:rvnow/features/learning/learning_list/blocs/get_learning_lists_bloc.dart';
import '../models/migrate.dart';
import '../services/knowledge_service.dart';

import 'get_for_migration_bloc.dart';

abstract class MigrateEvent {}

class StartMigration extends MigrateEvent {
  final MigrateRequest request;

  StartMigration(this.request);
}

abstract class MigrateState {}

class MigrationInitial extends MigrateState {}

class MigrationInProgress extends MigrateState {}

class MigrationSuccess extends MigrateState {}

class MigrationFailure extends MigrateState {
  List<String> errors = [];

  MigrationFailure(this.errors);
}

class MigrateBloc extends Bloc<MigrateEvent, MigrateState> {
  final KnowledgeService knowledgeService;
  final GetForMigrationBloc getForMigrationBloc;
  final GetCurrentUserLearningsBloc _getCurrentUserLearningsBloc;
  final UnlistedLearningsBloc _unlistedLearningsBloc;
  final GetLearningListByIdBloc _getLearningListByIdBloc;
  final GetLearningListsBloc _getLearningListsBloc;

  MigrateBloc(
      this.knowledgeService,
      this.getForMigrationBloc,
      this._getCurrentUserLearningsBloc,
      this._unlistedLearningsBloc,
      this._getLearningListByIdBloc,
      this._getLearningListsBloc)
      : super(MigrationInitial()) {
    on<StartMigration>((event, emit) async {
      emit(MigrationInProgress());
      var response = await knowledgeService.migrateKnowledges(event.request);
      await response.on(
          onFailure: (errors, _) => emit(MigrationFailure(errors)),
          onSuccess: (data) {
            getForMigrationBloc.add(KnowledgesMigrated(data));

            if (_getCurrentUserLearningsBloc.state is LearningsLoaded) {
              final state =
                  _getCurrentUserLearningsBloc.state as LearningsLoaded;
              _getCurrentUserLearningsBloc.add(LearningsUpdated((() {
                final updatedKnowledges = state.knowledges +
                    data
                        .map((l) => l.knowledge!.copyWith(
                            currentUserLearning: l.copyWith(knowledge: null)))
                        .toList();
                updatedKnowledges.sort((a, b) => a
                    .currentUserLearning!.nextReviewDate
                    .compareTo(b.currentUserLearning!.nextReviewDate));
                return updatedKnowledges;
              })()));
            }

            if (_unlistedLearningsBloc.state is UnlistedLearningsLoaded) {
              _unlistedLearningsBloc
                  .add(FetchUnlistedLearnings(knowledges: null));
            }

            if (_getLearningListByIdBloc.state is GetLearningListByIdSuccess) {
              final state =
                  _getLearningListByIdBloc.state as GetLearningListByIdSuccess;
              _getLearningListByIdBloc.add(GetLearningListByIdRequested(
                  state.learningList.id,
                  learningList: null));
            }

            _getLearningListsBloc
                .add(GetLearningListsRequested(learningLists: null));

            emit(MigrationSuccess());
          });
    });
  }
}
