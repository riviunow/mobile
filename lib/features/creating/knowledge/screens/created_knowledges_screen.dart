import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/creating/knowledge/blocs/created_knowledges_bloc.dart';
import 'package:rvnow/features/creating/knowledge/models/get_created.dart';
import 'package:rvnow/features/creating/knowledge/widgets/created_knowledge_list.dart';
import 'package:rvnow/features/creating/publication_request/screens/publication_requests_screen.dart';
import 'package:rvnow/shared/widgets/loader.dart';

class CreatedKnowledgesScreen extends StatefulWidget {
  const CreatedKnowledgesScreen({super.key});

  static route() {
    return MaterialPageRoute<void>(builder: (_) {
      return const CreatedKnowledgesScreen();
    });
  }

  @override
  State<CreatedKnowledgesScreen> createState() =>
      _CreatedKnowledgesScreenState();
}

class _CreatedKnowledgesScreenState extends State<CreatedKnowledgesScreen> {
  late GetCreatedKnowledgesRequest _request;

  @override
  void initState() {
    super.initState();
    _request = GetCreatedKnowledgesRequest();
    context.read<CreatedKnowledgesBloc>().add(GetCreatedKnowledges(_request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your_created_knowledges'.tr()),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Stack(
        children: [
          BlocBuilder<CreatedKnowledgesBloc, CreatedKnowledgesState>(
            builder: (context, state) {
              if (state is CreatedKnowledgesLoading) {
                return const Center(child: Loading());
              } else if (state is CreatedKnowledgesLoaded) {
                return CreatedKnowledgeList(
                  knowledges: state.knowledges,
                  hasNext: state.hasNext,
                  onLoadMore: () {
                    _request = _request.copyWith(page: _request.page + 1);
                    context
                        .read<CreatedKnowledgesBloc>()
                        .add(LoadMoreCreatedKnowledges(_request));
                  },
                );
              } else if (state is CreatedKnowledgesError) {
                return Center(
                    child: Text('Error: ${state.messages.join('\n')}'));
              } else {
                return Center(child: Text('no_data_available'.tr()));
              }
            },
          ),
          Positioned(
              bottom: 18,
              left: 0,
              right: 0,
              child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context, PublicationRequestsScreen.route()),
                  child: Text('view_publication_requests'.tr()))),
        ],
      ),
    );
  }
}
