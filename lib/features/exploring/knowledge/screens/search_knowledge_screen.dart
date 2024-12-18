import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/widgets/search.filter_widget.dart';
import 'package:udetxen/shared/widgets/layouts/authenticated_layout.dart';
import 'package:udetxen/shared/widgets/loader.dart';
import '../blocs/knowledge_bloc.dart';
import '../models/search_knowledge.dart';
import '../widgets/search.knowledge_list.dart';

class SearchKnowledgeScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AuthenticatedLayout(currentIndex: 1),
    );
  }

  const SearchKnowledgeScreen({super.key});

  @override
  State<SearchKnowledgeScreen> createState() => _SearchKnowledgeScreenState();
}

class _SearchKnowledgeScreenState extends State<SearchKnowledgeScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchKnowledgesRequest _searchRequest = SearchKnowledgesRequest();

  @override
  void initState() {
    super.initState();
    context.read<KnowledgeBloc>().add(SearchKnowledges(_searchRequest));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: SizedBox(
          height: 45,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon:
                  Icon(Icons.search, color: Theme.of(context).primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
            onSubmitted: (value) {
              setState(() {
                _searchRequest = _searchRequest.copyWith(searchTerm: value);
                context
                    .read<KnowledgeBloc>()
                    .add(SearchKnowledges(_searchRequest));
              });
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Theme.of(context).primaryColor,
              size: 34,
            ),
            onPressed: () async {
              final result = await showDialog<SearchKnowledgesRequest>(
                barrierColor: Theme.of(context).primaryColor.withOpacity(0.5),
                context: context,
                builder: (context) =>
                    SearchFilterWidget(request: _searchRequest),
              );
              if (result != null) {
                setState(() {
                  _searchRequest = result;
                  context
                      .read<KnowledgeBloc>()
                      .add(SearchKnowledges(_searchRequest));
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<KnowledgeBloc, KnowledgeState>(
              builder: (context, state) {
                if (state is KnowledgeLoading) {
                  return const Center(child: Loading());
                } else if (state is KnowledgeLoaded) {
                  return SearchKnowledgeList(
                    knowledges: state.knowledges,
                    hasNext: state.hasNext,
                    onLoadMore: () {
                      _searchRequest.copyWith(page: _searchRequest.page + 1);
                      context
                          .read<KnowledgeBloc>()
                          .add(LoadMoreKnowledges(_searchRequest));
                    },
                  );
                } else if (state is KnowledgeError) {
                  return Center(
                      child: Text('Error: ${state.messages.join('\n')}'));
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
