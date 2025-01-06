import 'package:flutter/material.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/enums/publication_request_status.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/widgets/loader.dart';

import 'delete_publication_request_dialog.dart';

class PublicationRequestList extends StatelessWidget {
  final List<PublicationRequest> publicationRequests;
  final bool hasNext;
  final VoidCallback onLoadMore;

  const PublicationRequestList({
    super.key,
    required this.publicationRequests,
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
        itemCount: publicationRequests.length + 1,
        itemBuilder: (context, index) {
          if (index == publicationRequests.length) {
            return hasNext
                ? const Center(child: Loading())
                : const Center(child: Text('No more items to load'));
          }
          final request = publicationRequests[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: Stack(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    request.knowledge?.title ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Status: ${request.status.toJson()}'),
                      const SizedBox(height: 8),
                      Text('Created at: ${request.createdAt}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'delete') {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              DeletePublicationRequestDialog(request: request),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        enabled:
                            request.status != PublicationRequestStatus.approved,
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    right: 8,
                    top: -3,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: request.status ==
                                PublicationRequestStatus.approved
                            ? AppColors.success
                            : request.status == PublicationRequestStatus.pending
                                ? AppColors.warning
                                : AppColors.error,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: Text(
                        request.status.toJson(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
