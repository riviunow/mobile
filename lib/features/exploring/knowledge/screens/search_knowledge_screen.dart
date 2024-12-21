import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/exploring/knowledge/widgets/search.filter_widget.dart';
import 'package:udetxen/shared/config/service_locator.dart';
import 'package:udetxen/shared/widgets/layouts/authenticated_layout.dart';
import 'package:udetxen/shared/widgets/loader.dart';
import '../blocs/search_knowledges_bloc.dart';
import '../models/search_knowledge.dart';
import '../widgets/search.knowledge_list.dart';

class SearchKnowledgeScreen extends StatefulWidget {
  final bool? searchFocus;
  final String? learningListId;

  const SearchKnowledgeScreen(
      {super.key, this.searchFocus = false, this.learningListId});

  static route() {
    return MaterialPageRoute<void>(builder: (_) {
      getIt<ValueNotifier<AuthenticatedLayoutSettings>>().value =
          getIt<ValueNotifier<AuthenticatedLayoutSettings>>()
              .value
              .copyWith(initialIndex: 1);
      return getIt<AuthenticatedLayout>();
    });
  }

  static Widget getInstance(
      {bool searchFocus = false, String? learningListId}) {
    return SearchKnowledgeScreen(
        searchFocus: searchFocus, learningListId: learningListId);
  }

  @override
  State<SearchKnowledgeScreen> createState() => _SearchKnowledgeScreenState();
}

class _SearchKnowledgeScreenState extends State<SearchKnowledgeScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late SearchKnowledgesRequest _searchRequest;

  @override
  void initState() {
    super.initState();
    _searchRequest = SearchKnowledgesRequest();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    if (widget.searchFocus == true) {
      _searchFocusNode.requestFocus();
    }

    context.read<SearchKnowledgesBloc>().add(SearchKnowledges(_searchRequest));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  if (Navigator.canPop(context))
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  else if (_searchFocusNode.hasFocus)
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                      },
                    ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          _searchRequest =
                              _searchRequest.copyWith(searchTerm: value);
                          context
                              .read<SearchKnowledgesBloc>()
                              .add(SearchKnowledges(_searchRequest));
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    onPressed: () async {
                      final result = await showDialog<SearchKnowledgesRequest>(
                        barrierColor:
                            Theme.of(context).primaryColor.withOpacity(0.5),
                        context: context,
                        builder: (context) =>
                            SearchFilterWidget(request: _searchRequest),
                      );
                      if (result != null) {
                        setState(() {
                          _searchRequest = result;
                          context
                              .read<SearchKnowledgesBloc>()
                              .add(SearchKnowledges(_searchRequest));
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchKnowledgesBloc, SearchKnowledgesState>(
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
                            .read<SearchKnowledgesBloc>()
                            .add(LoadMoreKnowledges(_searchRequest));
                      },
                      learningListId: widget.learningListId,
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
      ),
    );
  }
}
