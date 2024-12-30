import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/creating/knowledge/blocs/created_knowledges_bloc.dart';
import 'package:udetxen/features/creating/knowledge/models/get_created.dart';
import 'package:udetxen/features/creating/knowledge/widgets/created_knowledge_list.dart';
import 'package:udetxen/shared/widgets/loader.dart';

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
    _request = GetCreatedKnowledgesRequest(page: 1, pageSize: 10);
    context.read<CreatedKnowledgesBloc>().add(GetCreatedKnowledges(_request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Created Knowledges'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocBuilder<CreatedKnowledgesBloc, CreatedKnowledgesState>(
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
            return Center(child: Text('Error: ${state.messages.join('\n')}'));
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
