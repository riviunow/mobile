import 'package:flutter/material.dart';
import 'package:udetxen/features/creating/knowledge/screens/create_knowledge_screen.dart';
import 'package:udetxen/features/creating/knowledge/screens/created_knowledges_screen.dart';
import 'package:udetxen/features/exploring/track/widgets/home.app_bar.dart';
import 'package:udetxen/features/exploring/track/widgets/home.list_tracks.dart';
import 'package:udetxen/features/learning/knowledge_learning/screens/current_user_learning_screen.dart';
import 'package:udetxen/features/learning/learning_list/screens/learning_lists_screen.dart';
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
                      title: const Text("Review your Learning"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () =>
                          Navigator.push(context, LearningsScreen.route()),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text("Your Learning List"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () =>
                          Navigator.push(context, LearningListsScreen.route()),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                          labelText: "Title for your knowledge",
                          hintText: "Create your knowledge",
                          prefixIcon: const Icon(Icons.search),
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
                      title: const Text("View your Knowledges"),
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
