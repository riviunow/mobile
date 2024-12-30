import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/shared/models/index.dart';
import '../blocs/knowledge_topic_bloc.dart';
import '../models/knowledge_topic.dart';

class KnowledgeTopicFilter extends StatefulWidget {
  final List<String> knowledgeTopicIds;
  final ValueChanged<List<String>> onRequestUpdated;

  const KnowledgeTopicFilter({
    super.key,
    required this.knowledgeTopicIds,
    required this.onRequestUpdated,
  });

  @override
  State<KnowledgeTopicFilter> createState() => _KnowledgeTopicFilterState();
}

class _KnowledgeTopicFilterState extends State<KnowledgeTopicFilter> {
  final TextEditingController _topicSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: TextField(
            controller: _topicSearchController,
            decoration:
                const InputDecoration(labelText: 'Search Knowledge Topics'),
            onChanged: (value) {
              context.read<KnowledgeTopicBloc>().add(
                  GetKnowledgeTopics(KnowledgeTopicsRequest(search: value)));
            },
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<KnowledgeTopicBloc, KnowledgeTopicState>(
          builder: (context, state) {
            if (state is KnowledgeTopicLoading) {
              return const CircularProgressIndicator();
            } else if (state is KnowledgeTopicLoaded) {
              return _buildKnowledgeTopicExpansionList(state.knowledgeTopics);
            } else {
              return const Text('Failed to load knowledge topics');
            }
          },
        ),
      ],
    );
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
        value: widget.knowledgeTopicIds.contains(topic.id),
        title: Text(topic.title, style: const TextStyle(fontSize: 12)),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              widget.onRequestUpdated([
                ...widget.knowledgeTopicIds,
                topic.id,
                ..._getAllChildrenTopicIds(topic),
              ]);
            } else {
              widget.knowledgeTopicIds.remove(topic.id);
              _removeAllChildrenTopicIds(topic);
              widget.onRequestUpdated(widget.knowledgeTopicIds);
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
      widget.knowledgeTopicIds.remove(child.id);
      _removeAllChildrenTopicIds(child);
    }
  }
}
