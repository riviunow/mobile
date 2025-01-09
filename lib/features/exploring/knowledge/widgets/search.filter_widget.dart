import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/widgets/spaced_divider.dart';
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
    var typeBloc = context.read<KnowledgeTypeBloc>();
    if (typeBloc.state is! KnowledgeTypeLoaded) {
      typeBloc.add(GetKnowledgeTypes(KnowledgeTypesRequest()));
    }
    var topicBloc = context.read<KnowledgeTopicBloc>();
    if (topicBloc.state is! KnowledgeTopicLoaded) {
      topicBloc.add(GetKnowledgeTopics(KnowledgeTopicsRequest()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'filter'.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<OrderByType>(
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
                            decoration:
                                const InputDecoration(labelText: 'Order By'),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: DropdownButtonFormField<bool>(
                            value: _request.ascending ?? true,
                            items: [
                              DropdownMenuItem(
                                value: true,
                                child: Text('ascending'.tr()),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text('descending'.tr()),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _request = _request.copyWith(ascending: value);
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: 'Order'),
                          ),
                        ),
                      ],
                    ),
                    const SpacedDivider(spacing: 10),
                    KnowledgeTypeFilter(
                      selectedIds: _request.knowledgeTypeIds ?? [],
                      onRequestUpdated: (updatedIds) {
                        setState(() {
                          _request = _request.copyWith(
                            knowledgeTypeIds: updatedIds,
                          );
                        });
                      },
                    ),
                    const SpacedDivider(spacing: 10),
                    KnowledgeTopicFilter(
                      selectedIds: _request.knowledgeTopicIds ?? [],
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'cancel'.tr(),
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_request);
                  },
                  child: Text(
                    'apply'.tr(),
                    style: const TextStyle(color: AppColors.success),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
