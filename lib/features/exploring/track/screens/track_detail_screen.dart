import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/widgets/loader.dart';
import '../blocs/track_bloc.dart';
import '../widgets/track_detail.app_bar.dart';
import '../widgets/track_detail.list_subjects.dart';

class TrackDetailScreen extends StatefulWidget {
  final Track track;

  static route({required Track track}) {
    return MaterialPageRoute<void>(
      builder: (_) => TrackDetailScreen(track: track),
    );
  }

  const TrackDetailScreen({super.key, required this.track});

  @override
  State<TrackDetailScreen> createState() => _TrackDetailScreenState();
}

class _TrackDetailScreenState extends State<TrackDetailScreen> {
  @override
  void initState() {
    super.initState();
    var bloc = context.read<TrackBloc>();
    if (bloc.state is! TrackLoaded ||
        (bloc.state is TrackLoaded &&
            (bloc.state as TrackLoaded).track.id != widget.track.id)) {
      bloc.add(GetTrackById(widget.track.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TrackDetailAppBar(
        trackName: widget.track.name,
        trackDescription: widget.track.description,
      ),
      body: BlocBuilder<TrackBloc, TrackState>(
        builder: (context, state) {
          if (state is TrackLoading) {
            return const Center(child: Loading());
          } else if (state is TrackLoaded) {
            return TrackDetailListSubjects(track: state.track);
          } else if (state is TrackError) {
            return Center(child: Text('Error: ${state.messages.join('\n')}'));
          } else {
            return Center(child: Text('no_data_available'.tr()));
          }
        },
      ),
    );
  }
}
