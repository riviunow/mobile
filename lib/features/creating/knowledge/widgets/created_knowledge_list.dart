import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udetxen/features/creating/publication_request/screens/publish_knowledge_screen.dart';
import 'package:udetxen/features/creating/publication_request/widgets/delete_publication_request_dialog.dart';
import 'package:udetxen/features/exploring/knowledge/screens/knowledge_detail_screen.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/enums/knowledge_level.dart';
import 'package:udetxen/shared/models/enums/knowledge_visibility.dart';
import 'package:udetxen/shared/models/enums/publication_request_status.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import '../screens/update_knowledge_screen.dart';
import 'delete_knowledge_dialog.dart';

class CreatedKnowledgeList extends StatelessWidget {
  final List<Knowledge> knowledges;
  final bool hasNext;
  final VoidCallback onLoadMore;

  const CreatedKnowledgeList({
    super.key,
    required this.knowledges,
    required this.hasNext,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            hasNext) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: knowledges.length + 1,
        itemBuilder: (context, index) {
          if (index == knowledges.length) {
            return hasNext
                ? const Center(
                    child: Loading(
                    loaderType: LoaderType.wave,
                  ))
                : Center(child: Text('no_more_items_to_load'.tr()));
          }
          final knowledge = knowledges[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: Stack(
              children: [
                ListTile(
                  onTap: () => Navigator.push(context,
                      KnowledgeDetailScreen.route(knowledge: knowledge)),
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    knowledge.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Level: ${knowledge.level.toStr()}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'update') {
                        Navigator.push(
                          context,
                          UpdateKnowledgeScreen.route(knowledge),
                        );
                      } else if (result == 'delete') {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              DeleteKnowledgeDialog(knowledge: knowledge),
                        );
                      } else if (result == 'publish') {
                        Navigator.push(
                          context,
                          PublishKnowledgeScreen.route(knowledge),
                        );
                      } else if (result == 're-publish') {
                        Navigator.push(
                          context,
                          PublishKnowledgeScreen.route(knowledge),
                        );
                      } else if (result == 'delete-request') {
                        showDialog(
                          context: context,
                          builder: (context) => DeletePublicationRequestDialog(
                            request: knowledge.publicationRequest!,
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'update',
                        enabled:
                            knowledge.visibility == KnowledgeVisibility.private,
                        child: Text('update_knowledge'.tr()),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        enabled:
                            knowledge.visibility == KnowledgeVisibility.private,
                        child: Text('delete_knowledge'.tr()),
                      ),
                      if (knowledge.visibility == KnowledgeVisibility.private &&
                          knowledge.publicationRequest == null)
                        PopupMenuItem<String>(
                          value: 'publish',
                          child: Text('publish_knowledge'.tr()),
                        ),
                      if (knowledge.visibility == KnowledgeVisibility.private &&
                          knowledge.publicationRequest?.status ==
                              PublicationRequestStatus.rejected)
                        PopupMenuItem<String>(
                          value: 're-publish',
                          child: Text('re_publish_knowledge'.tr()),
                        ),
                      if (knowledge.publicationRequest != null &&
                          knowledge.publicationRequest?.status !=
                              PublicationRequestStatus.approved)
                        PopupMenuItem<String>(
                          value: 'delete-request',
                          child: Text('delete_publication_requet'.tr()),
                        ),
                    ],
                  ),
                ),
                Positioned(
                    right: 8,
                    top: -3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            knowledge.visibility == KnowledgeVisibility.public
                                ? AppColors.success
                                : AppColors.unselectedWidget,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            knowledge.visibility.toStr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (knowledge.visibility ==
                                  KnowledgeVisibility.private &&
                              knowledge.publicationRequest != null)
                            Text(
                              knowledge.publicationRequest!.status.toStr(),
                              style: TextStyle(
                                  color: knowledge.publicationRequest!.status ==
                                          PublicationRequestStatus.pending
                                      ? AppColors.warning
                                      : AppColors.error,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
