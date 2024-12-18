import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/shared/models/index.dart';
import '../blocs/knowledge_topic_bloc.dart';
import '../blocs/knowledge_type_bloc.dart';
import '../models/knowledge_topic.dart';
import '../models/knowledge_type.dart';
import '../models/search_knowledge.dart';

class SearchFilterWidget extends StatefulWidget {
  final SearchKnowledgesRequest request;

  const SearchFilterWidget({super.key, required this.request});

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  late SearchKnowledgesRequest _request;
  final TextEditingController _typeSearchController = TextEditingController();
  final TextEditingController _topicSearchController = TextEditingController();

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
            SizedBox(
              height: 40,
              child: TextField(
                controller: _typeSearchController,
                decoration:
                    const InputDecoration(labelText: 'Search Knowledge Types'),
                onChanged: (value) {
                  context.read<KnowledgeTypeBloc>().add(
                      GetKnowledgeTypes(KnowledgeTypesRequest(search: value)));
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
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: TextField(
                controller: _topicSearchController,
                decoration:
                    const InputDecoration(labelText: 'Search Knowledge Topics'),
                onChanged: (value) {
                  context.read<KnowledgeTopicBloc>().add(GetKnowledgeTopics(
                      KnowledgeTopicsRequest(search: value)));
                },
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<KnowledgeTopicBloc, KnowledgeTopicState>(
              builder: (context, state) {
                if (state is KnowledgeTopicLoading) {
                  return const CircularProgressIndicator();
                } else if (state is KnowledgeTopicLoaded) {
                  return _buildKnowledgeTopicExpansionList(
                      state.knowledgeTopics);
                } else {
                  return const Text('Failed to load knowledge topics');
                }
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
        value: _request.knowledgeTypeIds?.contains(type.id) ?? false,
        title: Text(type.name, style: const TextStyle(fontSize: 12)),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _request.knowledgeTypeIds = [
                ...?_request.knowledgeTypeIds,
                type.id,
                ..._getAllChildrenIds(type)
              ];
            } else {
              _request.knowledgeTypeIds?.remove(type.id);
              _removeAllChildrenIds(type);
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
      _request.knowledgeTypeIds?.remove(child.id);
      _removeAllChildrenIds(child);
    }
  }

  Widget _buildKnowledgeTopicExpansionList(
      List<KnowledgeTopic> knowledgeTopics) {
    return Column(
      children: _buildKnowledgeTopicExpansionItems(knowledgeTopics),
    );
  }

  List<Widget> _buildKnowledgeTopicExpansionItems(
      List<KnowledgeTopic> knowledgeTopics,
      {int level = 0}) {
    List<Widget> items = [];
    for (var topic in knowledgeTopics) {
      var tile = CheckboxListTile(
        value: _request.knowledgeTopicIds?.contains(topic.id) ?? false,
        title: Text(topic.title, style: const TextStyle(fontSize: 12)),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _request.knowledgeTopicIds = [
                ...?_request.knowledgeTopicIds,
                topic.id,
                ..._getAllChildrenTopicIds(topic)
              ];
            } else {
              _request.knowledgeTopicIds?.remove(topic.id);
              _removeAllChildrenTopicIds(topic);
            }
          });
        },
      );

      if (topic.children.isNotEmpty) {
        items.add(Container(
          margin:
              EdgeInsets.only(left: level * 2, right: level * 2, bottom: 4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ExpansionTile(
            title: tile,
            children: _buildKnowledgeTopicExpansionItems(topic.children,
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

  List<String> _getAllChildrenTopicIds(KnowledgeTopic topic) {
    List<String> ids = [];
    for (var child in topic.children) {
      ids.add(child.id);
      ids.addAll(_getAllChildrenTopicIds(child));
    }
    return ids;
  }

  void _removeAllChildrenTopicIds(KnowledgeTopic topic) {
    for (var child in topic.children) {
      _request.knowledgeTopicIds?.remove(child.id);
      _removeAllChildrenTopicIds(child);
    }
  }
}
