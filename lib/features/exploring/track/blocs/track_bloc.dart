import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/track/services/track_service.dart';
import 'package:udetxen/shared/models/index.dart';

abstract class TrackEvent {}

class GetTrackById extends TrackEvent {
  final String id;

  GetTrackById(this.id);
}

abstract class TrackState {}

class TrackInitial extends TrackState {}

class TrackLoading extends TrackState {}

class TrackLoaded extends TrackState {
  final Track track;

  TrackLoaded(this.track);
}

class TrackError extends TrackState {
  final List<String> messages;

  TrackError({this.messages = const []});
}

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final TrackService _trackService;

  TrackBloc(this._trackService) : super(TrackInitial()) {
    on<GetTrackById>((event, emit) async {
      emit(TrackLoading());
      var response = await _trackService.getTrackById(event.id);
      await response.on(onFailure: (errors, _) {
        emit(TrackError(messages: errors));
      }, onSuccess: (track) {
        emit(TrackLoaded(track));
      });
    });
  }
}
