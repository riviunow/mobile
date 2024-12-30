import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/shared/models/index.dart';
import '../blocs/knowledge_type_bloc.dart';
import '../models/knowledge_type.dart';

class KnowledgeTypeFilter extends StatefulWidget {
  final List<String> knowledgeTypeIds;
  final ValueChanged<List<String>> onRequestUpdated;

  const KnowledgeTypeFilter({
    super.key,
    required this.knowledgeTypeIds,
    required this.onRequestUpdated,
  });

  @override
  State<KnowledgeTypeFilter> createState() => _KnowledgeTypeFilterState();
}

class _KnowledgeTypeFilterState extends State<KnowledgeTypeFilter> {
  final TextEditingController _typeSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: TextField(
            controller: _typeSearchController,
            decoration:
                const InputDecoration(labelText: 'Search Knowledge Types'),
            onChanged: (value) {
              context
                  .read<KnowledgeTypeBloc>()
                  .add(GetKnowledgeTypes(KnowledgeTypesRequest(search: value)));
            },
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<KnowledgeTypeBloc, KnowledgeTypeState>(
          builder: (context, state) {
            if (state is KnowledgeTypeLoading) {
              return const CircularProgressIndicator();
            } else if (state is KnowledgeTypeLoaded) {
              return _buildKnowledgeTypeExpansionList(state.knowledgeTypes);
            } else {
              return const Text('Failed to load knowledge types');
            }
          },
        ),
      ],
    );
  }

  Widget _buildKnowledgeTypeExpansionList(List<KnowledgeType> knowledgeTypes) {
    return Column(
      children: _buildKnowledgeTypeExpansionItems(knowledgeTypes),
    );
  }

  List<Widget> _buildKnowledgeTypeExpansionItems(
      List<KnowledgeType> knowledgeTypes,
      {int level = 0}) {
    List<Widget> items = [];
    for (var type in knowledgeTypes) {
      var tile = CheckboxListTile(
        value: widget.knowledgeTypeIds.contains(type.id),
        title: Text(type.name, style: const TextStyle(fontSize: 12)),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              widget.onRequestUpdated([
                ...widget.knowledgeTypeIds,
                type.id,
                ..._getAllChildrenIds(type),
              ]);
            } else {
              widget.knowledgeTypeIds.remove(type.id);
              _removeAllChildrenIds(type);
              widget.onRequestUpdated(widget.knowledgeTypeIds);
            }
          });
        },
      );

      if (type.children.isNotEmpty) {
        items.add(Container(
          margin:
              EdgeInsets.only(left: level * 2, right: level * 2, bottom: 4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ExpansionTile(
            title: tile,
            children: _buildKnowledgeTypeExpansionItems(type.children,
                level: level + 1),
          ),
        ));
      } else {
        items.add(Container(
          margin:
              EdgeInsets.only(left: level * 2, right: level * 2, bottom: 4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: tile,
        ));
      }
    }
    return items;
  }

  List<String> _getAllChildrenIds(KnowledgeType type) {
    List<String> ids = [];
    for (var child in type.children) {
      ids.add(child.id);
      ids.addAll(_getAllChildrenIds(child));
    }
    return ids;
  }

  void _removeAllChildrenIds(KnowledgeType type) {
    for (var child in type.children) {
      widget.knowledgeTypeIds.remove(child.id);
      _removeAllChildrenIds(child);
    }
  }
}
