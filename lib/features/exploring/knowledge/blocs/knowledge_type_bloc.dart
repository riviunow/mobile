import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/models/knowledge_type.dart';
import 'package:udetxen/features/exploring/knowledge/services/knowledge_type_service.dart';
import 'package:udetxen/shared/models/index.dart';

abstract class KnowledgeTypeEvent {}

class GetKnowledgeTypes extends KnowledgeTypeEvent {
  final KnowledgeTypesRequest request;

  GetKnowledgeTypes(this.request);
}

abstract class KnowledgeTypeState {}

class KnowledgeTypeInitial extends KnowledgeTypeState {}

class KnowledgeTypeLoading extends KnowledgeTypeState {}

class KnowledgeTypeLoaded extends KnowledgeTypeState {
  final List<KnowledgeType> knowledgeTypes;

  KnowledgeTypeLoaded(this.knowledgeTypes);
}

class KnowledgeTypeError extends KnowledgeTypeState {
  final List<String> messages;

  KnowledgeTypeError({this.messages = const []});
}

class KnowledgeTypeBloc extends Bloc<KnowledgeTypeEvent, KnowledgeTypeState> {
  final KnowledgeTypeService _knowledgeTypeService;

  KnowledgeTypeBloc(this._knowledgeTypeService)
      : super(KnowledgeTypeInitial()) {
    on<GetKnowledgeTypes>((event, emit) async {
      emit(KnowledgeTypeLoading());
      var response =
          await _knowledgeTypeService.getKnowledgeTypes(event.request);
      await response.on(onFailure: (errors, _) {
        emit(KnowledgeTypeError(messages: errors));
      }, onSuccess: (knowledgeTypes) {
        emit(KnowledgeTypeLoaded(knowledgeTypes));
      });
    });
  }
}
