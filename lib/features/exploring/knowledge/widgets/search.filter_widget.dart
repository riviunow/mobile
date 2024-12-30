import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/knowledge_topic_bloc.dart';
import '../blocs/knowledge_type_bloc.dart';
import '../models/knowledge_topic.dart';
import '../models/knowledge_type.dart';
import '../models/search_knowledge.dart';
import 'knowledge_topic_filter.dart';
import 'knowledge_type_filter.dart';

class SearchFilterWidget extends StatefulWidget {
  final SearchKnowledgesRequest request;

  const SearchFilterWidget({super.key, required this.request});

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  late SearchKnowledgesRequest _request;

  @override
  void initState() {
    super.initState();
    _request = widget.request.copyWith();
    context
        .read<KnowledgeTypeBloc>()
        .add(GetKnowledgeTypes(KnowledgeTypesRequest()));
    context
        .read<KnowledgeTopicBloc>()
        .add(GetKnowledgeTopics(KnowledgeTopicsRequest()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<OrderByType>(
              value: _request.orderBy,
              items: OrderByType.values.map((OrderByType type) {
                return DropdownMenuItem<OrderByType>(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _request = _request.copyWith(orderBy: value);
                });
              },
              decoration: const InputDecoration(labelText: 'Order By'),
            ),
            SwitchListTile(
              title: const Text('Ascending'),
              value: _request.ascending ?? true,
              onChanged: (value) {
                setState(() {
                  _request = _request.copyWith(ascending: value);
                });
              },
            ),
            KnowledgeTypeFilter(
              knowledgeTypeIds: _request.knowledgeTypeIds ?? [],
              onRequestUpdated: (updatedIds) {
                setState(() {
                  _request = _request.copyWith(
                    knowledgeTypeIds: updatedIds,
                  );
                });
              },
            ),
            KnowledgeTopicFilter(
              knowledgeTopicIds: _request.knowledgeTopicIds ?? [],
              onRequestUpdated: (updatedIds) {
                setState(() {
                  _request = _request.copyWith(
                    knowledgeTopicIds: updatedIds,
                  );
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_request);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
