import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/track/services/track_service.dart';
import 'package:udetxen/shared/models/index.dart';

abstract class ListTracksEvent {}

class GetListTracks extends ListTracksEvent {}

abstract class ListTracksState {}

class ListTracksInitial extends ListTracksState {}

class ListTracksLoading extends ListTracksState {}

class ListTracksLoaded extends ListTracksState {
  final List<Track> tracks;

  ListTracksLoaded(this.tracks);
}

class ListTracksError extends ListTracksState {
  final List<String> messages;

  ListTracksError({this.messages = const []});
}

class ListTracksBloc extends Bloc<ListTracksEvent, ListTracksState> {
  final TrackService _trackService;

  ListTracksBloc(this._trackService) : super(ListTracksInitial()) {
    on<GetListTracks>((event, emit) async {
      emit(ListTracksLoading());
      var response = await _trackService.getDetailedTracks();
      await response.on(onFailure: (errors, _) {
        emit(ListTracksError(messages: errors));
      }, onSuccess: (listTracks) {
        emit(ListTracksLoaded(listTracks));
      });
    });
  }
}
