import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/screens/search_knowledge_screen.dart';
import 'package:udetxen/features/learning/learning_list/blocs/get_learning_list_by_id_bloc.dart';
import 'package:udetxen/features/learning/learning_list/screens/remove_learning_list_screen.dart';
import 'package:udetxen/features/learning/learning_list/screens/update_learning_list_screen.dart';
import 'package:udetxen/features/learning/learning_list/widgets/by_id.header.dart';
import 'package:udetxen/shared/config/service_locator.dart';
import 'package:udetxen/shared/widgets/layouts/authenticated_layout.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import '../widgets/by_id.knowledges_list.dart';

class GetLearningListByIdScreen extends StatefulWidget {
  final String learningListId;

  static route(String learningListId) {
    return MaterialPageRoute<void>(
      builder: (_) => GetLearningListByIdScreen(learningListId: learningListId),
    );
  }

  const GetLearningListByIdScreen({super.key, required this.learningListId});

  @override
  State<GetLearningListByIdScreen> createState() =>
      _GetLearningListByIdScreenState();
}

class _GetLearningListByIdScreenState extends State<GetLearningListByIdScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<GetLearningListByIdBloc>()
        .add(GetLearningListByIdRequested(widget.learningListId));
  }

  void _onSearch(GetLearningListByIdSuccess state) async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchKnowledgeScreen.getInstance(
          searchFocus: true, learningListId: state.learningList.id);
    }));
    if (result == true) {
      getIt<ValueNotifier<AuthenticatedLayoutSettings>>().value =
          getIt<ValueNotifier<AuthenticatedLayoutSettings>>()
              .value
              .copyWith(initialIndex: 2, initialLearningListIndex: 1);
    }
  }

  void _onMore(GetLearningListByIdSuccess state) async {
    var result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, size: 28),
                title: const Text('Update', style: TextStyle(fontSize: 18)),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(context,
                      UpdateLearningListScreen.route(state.learningList));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, size: 28),
                title: const Text('Remove', style: TextStyle(fontSize: 18)),
                onTap: () async {
                  var result = await Navigator.push(context,
                      RemoveLearningListScreen.route(state.learningList.id));
                  result != null
                      ? Navigator.pop(context, result)
                      : Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GetLearningListByIdBloc, GetLearningListByIdState>(
          builder: (context, state) {
            if (state is GetLearningListByIdLoading) {
              return const Center(child: Loading());
            } else if (state is GetLearningListByIdSuccess) {
              final learningList = state.learningList;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ByIdHeader(
                      onBack: () => Navigator.pop(context),
                      onSearch: () => _onSearch(state),
                      onMore: () => _onMore(state),
                    ),
                    const SizedBox(height: 4),
                    Text(learningList.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    if (learningList.noKnowledge) ...[
                      const Text('No knowledge items in this list.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _onSearch(state),
                        child: const Text('Add Knowledge'),
                      ),
                    ] else
                      Expanded(
                        child: ByIdKnowledgesList(learningList: learningList),
                      ),
                  ],
                ),
              );
            } else if (state is GetLearningListByIdError) {
              return Center(child: Text('Error: ${state.messages.join('\n')}'));
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
