import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udetxen/features/creating/knowledge/screens/create_knowledge_screen.dart';
import 'package:udetxen/features/creating/knowledge/screens/created_knowledges_screen.dart';
import 'package:udetxen/features/exploring/track/widgets/home.app_bar.dart';
import 'package:udetxen/features/exploring/track/widgets/home.list_tracks.dart';
import 'package:udetxen/features/learning/knowledge_learning/screens/current_user_learning_screen.dart';
import 'package:udetxen/features/learning/learning_list/screens/learning_lists_screen.dart';
import 'package:udetxen/features/migration/screens/migration_screen.dart';
import 'package:udetxen/shared/config/service_locator.dart';
import 'package:udetxen/shared/widgets/layouts/authenticated_layout.dart';

class HomeScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute<void>(
      builder: (_) => getInstance(),
    );
  }

  static Widget getInstance() {
    getIt<ValueNotifier<AuthenticatedLayoutSettings>>().value =
        getIt<ValueNotifier<AuthenticatedLayoutSettings>>()
            .value
            .copyWith(initialIndex: 0);
    return getIt<AuthenticatedLayout>();
  }

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 50.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: const FlexibleSpaceBar(
                background: HomeAppBar(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              sliver: HomeListTracks(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text("start_migration".tr()),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () =>
                          Navigator.push(context, MigrationScreen.route()),
                    ),
                    ListTile(
                      title: Text("review_your".tr()),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () =>
                          Navigator.push(context, LearningsScreen.route()),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text("your_learning_lists".tr()),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () =>
                          Navigator.push(context, LearningListsScreen.route()),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "create_your_knowledge".tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onSubmitted: (value) => Navigator.push(
                            context, CreateKnowledgeScreen.route(title: value)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text("view_your_knowledges".tr()),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => Navigator.push(
                          context, CreatedKnowledgesScreen.route()),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
