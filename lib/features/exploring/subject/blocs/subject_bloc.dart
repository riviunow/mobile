import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/subject/services/subject_service.dart';
import 'package:udetxen/shared/models/index.dart';

abstract class SubjectEvent {}

class GetSubjectById extends SubjectEvent {
  final String id;

  GetSubjectById(this.id);
}

abstract class SubjectState {}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final Subject subject;

  SubjectLoaded(this.subject);
}

class SubjectError extends SubjectState {
  final List<String> messages;

  SubjectError({this.messages = const []});
}

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectService _subjectService;

  SubjectBloc(this._subjectService) : super(SubjectInitial()) {
    on<GetSubjectById>((event, emit) async {
      emit(SubjectLoading());
      var response = await _subjectService.getSubjectById(event.id);
      await response.on(onFailure: (errors, _) {
        emit(SubjectError(messages: errors));
      }, onSuccess: (subject) {
        emit(SubjectLoaded(subject));
      });
    });
  }
}
