import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/learning/learn_and_review/screens/learn_knowledge_screen.dart';
import 'package:rvnow/features/learning/learn_and_review/screens/review_knowledge_screen.dart';
import 'package:rvnow/features/learning/learning_list/blocs/add_remove_knowledges_bloc.dart';
import 'package:rvnow/features/learning/learning_list/blocs/get_learning_list_by_id_bloc.dart';
import 'package:rvnow/features/learning/learning_list/models/add_remove_knowledges.dart';
import 'package:rvnow/features/profile/bloc/profile_bloc.dart';
import 'package:rvnow/shared/config/service_locator.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/widgets/layouts/authenticated_layout.dart';
import 'package:rvnow/shared/widgets/loader.dart';
import '../blocs/search_knowledges_bloc.dart';
import '../models/search_knowledge.dart';
import '../widgets/knowledge_list.dart';
import '../widgets/learning_list_dialog.dart';
import '../widgets/search.filter_widget.dart';
import 'knowledge_detail_screen.dart';

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
  bool _isSelectionMode = false;
  final Set<Knowledge> _selectedKnowledges = {};
  bool _isLoadingMore = false;
  Timer? _debounce;
  LearningList? learningList;

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedKnowledges.clear();
      }
    });
  }

  void _onKnowledgeSelected(Knowledge knowledge) {
    setState(() {
      if (_selectedKnowledges.any((element) => element.id == knowledge.id)) {
        _selectedKnowledges
            .removeWhere((element) => element.id == knowledge.id);
      } else {
        _selectedKnowledges.add(knowledge);
      }
    });
  }

  void _onLoadMore() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
        });
        _searchRequest = _searchRequest.copyWith(page: _searchRequest.page + 1);
        context
            .read<SearchKnowledgesBloc>()
            .add(LoadMoreKnowledges(_searchRequest));
      }
    });
  }

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
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var profileBloc = context.read<ProfileBloc>();
    var profileState = profileBloc.state;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      if (Navigator.canPop(context) &&
                          widget.learningListId != null)
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
                            if (_searchController.value.text.isEmpty) {
                              _searchFocusNode.unfocus();
                            } else {
                              _searchController.clear();
                            }
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
                              if (value != _searchRequest.searchTerm) {
                                _searchRequest = _searchRequest.clearFilter(
                                    searchTerm: value, page: 1);
                                context
                                    .read<SearchKnowledgesBloc>()
                                    .add(SearchKnowledges(_searchRequest));
                              }
                            });
                          },
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.filter_list,
                              color: _searchRequest.hasFilters
                                  ? AppColors.warning
                                  : Theme.of(context).primaryColor,
                              size: 28,
                            ),
                            onPressed: () async {
                              final result =
                                  await showDialog<SearchKnowledgesRequest>(
                                barrierColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                context: context,
                                builder: (context) =>
                                    SearchFilterWidget(request: _searchRequest),
                              );
                              if (result != null &&
                                  _searchRequest.hasSimilarFilter(result) ==
                                      false) {
                                setState(() {
                                  _searchRequest = result.copyWith(
                                      page: 1,
                                      searchTerm: _searchController.text);
                                  context
                                      .read<SearchKnowledgesBloc>()
                                      .add(SearchKnowledges(_searchRequest));
                                });
                              }
                            },
                          ),
                          if (_searchRequest.hasFilters)
                            const Positioned(
                              bottom: 6,
                              right: 6,
                              child: Icon(
                                Icons.check,
                                color: AppColors.warning,
                                size: 14,
                              ),
                            ),
                        ],
                      ),
                      if (profileState is! UnauthenticatedProfile)
                        IconButton(
                          icon: Icon(_isSelectionMode
                              ? Icons.cancel
                              : Icons.select_all),
                          onPressed: _toggleSelectionMode,
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      BlocBuilder<SearchKnowledgesBloc, SearchKnowledgesState>(
                    builder: (context, state) {
                      if (state is KnowledgeLoading) {
                        return const Center(child: Loading());
                      } else if (state is KnowledgeLoaded) {
                        _isLoadingMore = false;
                        return BlocBuilder<GetLearningListByIdBloc,
                            GetLearningListByIdState>(
                          builder: (context, listState) {
                            if (widget.learningListId != null &&
                                listState is GetLearningListByIdSuccess) {
                              learningList = listState.learningList;
                            }

                            return KnowledgeList(
                              knowledges: state.knowledges,
                              hasNext: state.hasNext,
                              onLoadMore: _onLoadMore,
                              learningList: learningList,
                              isSelectionMode: _isSelectionMode,
                              selectedKnowledgeIds:
                                  _selectedKnowledges.map((e) => e.id).toSet(),
                              onKnowledgeSelected: _isSelectionMode
                                  ? _onKnowledgeSelected
                                  : (knowledge) => Navigator.push(
                                      context,
                                      KnowledgeDetailScreen.route(
                                          knowledge: knowledge)),
                            );
                          },
                        );
                      } else if (state is KnowledgeError) {
                        return Center(child: Text(state.messages.join('\n')));
                      } else {
                        return Center(child: Text('no_data_available'.tr()));
                      }
                    },
                  ),
                ),
              ],
            ),
            if (_isSelectionMode && profileState is! UnauthenticatedProfile)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warning,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _toggleSelectionMode(),
                            child: Text(
                              'cancel'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warning,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedKnowledges.clear();
                              });
                            },
                            child: Text(
                              'clear'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                        ),
                        if (widget.learningListId == null &&
                            _selectedKnowledges.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _selectedKnowledges.every(
                                      (e) => e.currentUserLearning == null)
                                  ? () {
                                      Navigator.push(
                                          context,
                                          LearnKnowledgeScreen.route(
                                              knowledgeIds: _selectedKnowledges
                                                  .map((e) => e.id)
                                                  .toList()));
                                      _toggleSelectionMode();
                                    }
                                  : _selectedKnowledges.every(
                                          (e) => e.currentUserLearning != null)
                                      ? () {
                                          Navigator.push(
                                              context,
                                              ReviewKnowledgeScreen.route(
                                                  knowledgeIds:
                                                      _selectedKnowledges
                                                          .map((e) => e.id)
                                                          .toList()));
                                          _toggleSelectionMode();
                                        }
                                      : null,
                              child: Text(
                                _selectedKnowledges.every(
                                        (e) => e.currentUserLearning != null)
                                    ? "${"review".tr()} (${_selectedKnowledges.length})"
                                    : "${"learn".tr()} (${_selectedKnowledges.length})",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                          ),
                        ],
                        if (widget.learningListId != null) ...[
                          const SizedBox(width: 4),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _selectedKnowledges.every((e) =>
                                      learningList!.containsKnowledge(e.id))
                                  ? () => context
                                      .read<AddRemoveKnowledgesBloc>()
                                      .add(AddRemoveKnowledgesRequested(
                                          AddRemoveKnowledgesRequest(
                                              knowledgeIds: _selectedKnowledges
                                                  .map((e) => e.id)
                                                  .toList(),
                                              isAdd: false,
                                              learningListId:
                                                  widget.learningListId!)))
                                  : _selectedKnowledges.every((e) =>
                                          !learningList!
                                              .containsKnowledge(e.id))
                                      ? () => context
                                          .read<AddRemoveKnowledgesBloc>()
                                          .add(AddRemoveKnowledgesRequested(AddRemoveKnowledgesRequest(isAdd: true, knowledgeIds: _selectedKnowledges.map((e) => e.id).toList(), learningListId: widget.learningListId!)))
                                      : null,
                              child: Text(
                                _selectedKnowledges.every((e) =>
                                        learningList!.containsKnowledge(e.id))
                                    ? '${"remove".tr()} ${_selectedKnowledges.length}'
                                    : '${"add".tr()} ${_selectedKnowledges.length}',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(width: 4),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _selectedKnowledges.isEmpty
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        LearningListDialog.route(
                                            _selectedKnowledges
                                                .map((e) => e.id)
                                                .toList()),
                                      );
                                      _toggleSelectionMode();
                                    },
                              child: Text(
                                'add_to_list'.tr(),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
