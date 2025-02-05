import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/index.dart';
import '../models/knowledge_type.dart';
import '../blocs/knowledge_type_bloc.dart';

class KnowledgeTypeFilter extends StatefulWidget {
  final List<String> selectedIds;
  final ValueChanged<List<String>> onRequestUpdated;

  const KnowledgeTypeFilter({
    super.key,
    required this.selectedIds,
    required this.onRequestUpdated,
  });

  @override
  State<KnowledgeTypeFilter> createState() => _KnowledgeTypeFilterState();
}

class _KnowledgeTypeFilterState extends State<KnowledgeTypeFilter> {
  final TextEditingController _typeSearchController = TextEditingController();
  final List<KnowledgeType> _breadcrumb = [];
  String _searchValue = '';
  List<String> _selectedIds = [];

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedIds);
    context
        .read<KnowledgeTypeBloc>()
        .add(GetKnowledgeTypes(KnowledgeTypesRequest()));
  }

  void _onKnowledgeTypeSelected(KnowledgeType knowledgeType) {
    setState(() {
      if (_selectedIds.contains(knowledgeType.id)) {
        _selectedIds.remove(knowledgeType.id);
      } else {
        _selectedIds.add(knowledgeType.id);
      }
      widget.onRequestUpdated(_selectedIds);
    });
  }

  void _onBack() {
    setState(() {
      if (_breadcrumb.isNotEmpty) {
        _breadcrumb.removeLast();
      }
    });
  }

  void _onSearch(String value) {
    setState(() {
      _searchValue = value.trim();
      _breadcrumb.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _typeSearchController,
          decoration: InputDecoration(
            labelText: 'search_knowledge_type'.tr(),
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onSubmitted: _onSearch,
        ),
        const SizedBox(height: 5),
        if (_breadcrumb.isNotEmpty) ...[
          GestureDetector(
            onTap: _onBack,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_back,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      _breadcrumb.map((e) => e.name).join(' > '),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
        BlocBuilder<KnowledgeTypeBloc, KnowledgeTypeState>(
          builder: (context, state) {
            if (state is KnowledgeTypeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is KnowledgeTypeLoaded) {
              var knowledgeTypes = _breadcrumb.isEmpty
                  ? state.knowledgeTypes
                  : _breadcrumb.last.children;
              if (_searchValue.isNotEmpty) {
                knowledgeTypes = knowledgeTypes
                    .where((element) => element.recursiveContains(_searchValue))
                    .toList();
              }
              return Column(
                children: [
                  _buildKnowledgeTypeList(knowledgeTypes),
                  const SizedBox(height: 5),
                  if (_selectedIds.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.hint.withOpacity(0.1),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          '(${_selectedIds.length}) ${"selected".tr()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        initiallyExpanded: true,
                        children: _selectedIds.map((id) {
                          final type = recursiveFind(state.knowledgeTypes, id);
                          if (type == null) {
                            return ListTile(
                              title: Text('no_type_found'.tr()),
                            );
                          }
                          return ListTile(
                            title: Text(
                              type.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: AppColors.error,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedIds.remove(id);
                                  widget.onRequestUpdated(_selectedIds);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              );
            } else {
              return Center(child: Text('no_more_items_to_load'.tr()));
            }
          },
        ),
      ],
    );
  }

  Widget _buildKnowledgeTypeList(List<KnowledgeType> knowledgeTypes) {
    return Column(
      children: knowledgeTypes.map((knowledgeType) {
        final isSelected = _selectedIds.contains(knowledgeType.id);
        final hasChildren = knowledgeType.children.isNotEmpty;
        return GestureDetector(
          onTap: () {
            if (hasChildren) {
              setState(() {
                _breadcrumb.add(knowledgeType);
              });
            } else {
              _onKnowledgeTypeSelected(knowledgeType);
            }
          },
          child: hasChildren
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  margin: const EdgeInsets.symmetric(vertical: 2.0),
                  decoration: BoxDecoration(
                    color: AppColors.hint.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        knowledgeType.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  margin: const EdgeInsets.symmetric(vertical: 2.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary.withOpacity(0.2)
                        : AppColors.hint.withOpacity(0.2),
                    border: Border.all(
                      color: isSelected ? AppColors.secondary : AppColors.hint,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        knowledgeType.name,
                        style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.secondary
                                : Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
        );
      }).toList(),
    );
  }
}

KnowledgeType? recursiveFind(List<KnowledgeType> knowledgeTypes, String id) {
  for (final type in knowledgeTypes) {
    if (type.id == id) {
      return type;
    }
    final child = recursiveFind(type.children, id);
    if (child != null) {
      return child;
    }
  }
  return null;
}
