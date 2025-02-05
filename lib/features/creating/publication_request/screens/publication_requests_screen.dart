import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/creating/publication_request/blocs/get_publication_requests_bloc.dart';
import 'package:rvnow/features/creating/publication_request/models/get_requests.dart';
import 'package:rvnow/features/creating/publication_request/widgets/publication_request_list.dart';
import 'package:rvnow/shared/widgets/loader.dart';

class PublicationRequestsScreen extends StatefulWidget {
  const PublicationRequestsScreen({super.key});

  static route() {
    return MaterialPageRoute<void>(builder: (_) {
      return const PublicationRequestsScreen();
    });
  }

  @override
  State<PublicationRequestsScreen> createState() =>
      _PublicationRequestsScreenState();
}

class _PublicationRequestsScreenState extends State<PublicationRequestsScreen> {
  late GetPublicationRequests _request;

  @override
  void initState() {
    super.initState();
    _request = GetPublicationRequests(page: 1, pageSize: 10);
    var bloc = context.read<GetPublicationRequestsBloc>();
    if (bloc.state is! GetPublicationRequestsLoaded) {
      bloc.add(GetPublicationRequestsRequested(_request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('publication_requests'.tr()),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body:
          BlocBuilder<GetPublicationRequestsBloc, GetPublicationRequestsState>(
        builder: (context, state) {
          if (state is GetPublicationRequestsLoading) {
            return const Center(child: Loading());
          } else if (state is GetPublicationRequestsLoaded) {
            return PublicationRequestList(
              publicationRequests: state.publicationRequests,
              hasNext: state.hasNext,
              onLoadMore: () {
                _request = _request.copyWith(page: _request.page + 1);
                context
                    .read<GetPublicationRequestsBloc>()
                    .add(LoadMorePublicationRequests(_request));
              },
            );
          } else if (state is GetPublicationRequestsError) {
            return Center(child: Text('Error: ${state.messages.join('\n')}'));
          } else {
            return Center(child: Text('no_data_available'.tr()));
          }
        },
      ),
    );
  }
}
