// Events
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/migrate.dart';
import '../services/knowledge_service.dart';

import 'get_for_migration_bloc.dart';

abstract class MigrateEvent {}

class StartMigration extends MigrateEvent {
  final MigrateRequest request;

  StartMigration(this.request);
}

// States
abstract class MigrateState {}

class MigrationInitial extends MigrateState {}

class MigrationInProgress extends MigrateState {}

class MigrationSuccess extends MigrateState {}

class MigrationFailure extends MigrateState {
  List<String> errors = [];

  MigrationFailure(this.errors);
}

// Bloc
class MigrateBloc extends Bloc<MigrateEvent, MigrateState> {
  final KnowledgeService knowledgeService;
  final GetForMigrationBloc getForMigrationBloc;

  MigrateBloc(this.knowledgeService, this.getForMigrationBloc)
      : super(MigrationInitial()) {
    on<StartMigration>((event, emit) async {
      emit(MigrationInProgress());
      var response = await knowledgeService.migrateKnowledges(event.request);
      await response.on(
          onFailure: (errors, _) => emit(MigrationFailure(errors)),
          onSuccess: (data) {
            getForMigrationBloc.add(KnowledgesMigrated(data));
            emit(MigrationSuccess());
          });
    });
  }
}
