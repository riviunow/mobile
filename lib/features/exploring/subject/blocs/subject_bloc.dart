import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/subject/services/subject_service.dart';
import 'package:udetxen/features/exploring/track/blocs/track_bloc.dart';
import 'package:udetxen/shared/models/index.dart';

abstract class SubjectEvent {}

class GetSubjectById extends SubjectEvent {
  final String id;
  final Subject? subject;

  GetSubjectById(this.id, {this.subject});
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
  final TrackBloc _trackBloc;

  SubjectBloc(this._subjectService, this._trackBloc) : super(SubjectInitial()) {
    on<GetSubjectById>((event, emit) async {
      emit(SubjectLoading());

      if (event.subject != null) {
        emit(SubjectLoaded(event.subject!));
        if (_trackBloc.state is TrackLoaded) {
          var state = _trackBloc.state as TrackLoaded;
          _trackBloc.add(GetTrackById(state.track.id,
              track: state.track.copyWith(
                trackSubjects: state.track.trackSubjects
                    .map((ts) => ts.subjectId == event.subject!.id
                        ? ts.copyWith(
                            subject: ts.subject!.copyWith(
                            userLearningCount: event.subject!.subjectKnowledges
                                .where((sk) =>
                                    sk.knowledge!.currentUserLearning != null)
                                .length,
                          ))
                        : ts)
                    .toList(),
              )));
        }
        return;
      }

      var response = await _subjectService.getSubjectById(event.id);
      await response.on(onFailure: (errors, _) {
        emit(SubjectError(messages: errors));
      }, onSuccess: (subject) {
        emit(SubjectLoaded(subject));
      });
    });
  }
}
