import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rvnow/shared/models/index.dart';

class MigrationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<KnowledgeTopic> breadcrumb;
  final List<String> selectedKnowledgeIds;
  final VoidCallback onBack;
  final VoidCallback onMigrate;

  const MigrationAppBar({
    super.key,
    required this.breadcrumb,
    required this.selectedKnowledgeIds,
    required this.onBack,
    required this.onMigrate,
  });

  @override
  Widget build(BuildContext context) {
    var breadcrumbText = breadcrumb.map((e) => e.title).join(' > ');
    var breadcrumbParts = breadcrumbText.split(' > ');
    var displayedBreadcrumb = breadcrumbParts.length > 2
        ? '... > ${breadcrumbParts.sublist(breadcrumbParts.length - 2).join(' > ')}'
        : breadcrumbText;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (breadcrumb.isNotEmpty) {
            onBack();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      title: breadcrumb.isEmpty
          ? Text("select_to_migrate".tr())
          : Text(
              displayedBreadcrumb,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
