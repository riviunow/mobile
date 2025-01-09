import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/track/blocs/list_tracks_bloc.dart';
import '../screens/track_detail_screen.dart';

class HomeListTracks extends StatefulWidget {
  const HomeListTracks({super.key});

  @override
  State<HomeListTracks> createState() => _HomeListTracksState();
}

class _HomeListTracksState extends State<HomeListTracks> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ListTracksBloc>(context).add(GetListTracks());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListTracksBloc, ListTracksState>(
      builder: (context, state) {
        if (state is ListTracksLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ListTracksLoaded) {
          final tracks = state.tracks;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = tracks[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title:
                        Text(track.name, style: const TextStyle(fontSize: 22)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(track.description),
                        const SizedBox(height: 4),
                        Text('${track.subjectCount} ${"subjects".tr()}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        TrackDetailScreen.route(track: track),
                      );
                    },
                  ),
                );
              },
              childCount: tracks.length,
            ),
          );
        } else if (state is ListTracksError) {
          return SliverToBoxAdapter(
            child: Center(child: Text(state.messages.first)),
          );
        } else {
          return SliverToBoxAdapter(
            child: Center(child: Text('no_tracks_avalable'.tr())),
          );
        }
      },
    );
  }
}
