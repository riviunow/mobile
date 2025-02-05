import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/creating/knowledge/screens/create_knowledge_screen.dart';
import 'package:rvnow/features/creating/knowledge/screens/created_knowledges_screen.dart';
import 'package:rvnow/features/exploring/track/widgets/home.app_bar.dart';
import 'package:rvnow/features/exploring/track/widgets/home.list_tracks.dart';
import 'package:rvnow/features/learning/knowledge_learning/blocs/current_user_learnings_bloc.dart';
import 'package:rvnow/features/learning/learn_and_review/screens/review_knowledge_screen.dart';
import 'package:rvnow/features/learning/learning_list/screens/learning_lists_screen.dart';
import 'package:rvnow/features/migration/screens/migration_screen.dart';
import 'package:rvnow/shared/config/service_locator.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/widgets/layouts/authenticated_layout.dart';
import 'package:rvnow/shared/widgets/loader.dart';
import 'package:rvnow/shared/widgets/spaced_divider.dart';

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
              child: SizedBox(height: 2),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocBuilder<GetCurrentUserLearningsBloc,
                        GetCurrentUserLearningsState>(
                      builder: (context, state) {
                        if (state is LearningsLoading) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 3,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return const Card(
                                child: Center(
                                  child: LoadingSmall(
                                    loaderType: LoaderType.doubleBounce,
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is LearningsLoaded) {
                          var topKnowledges = state.knowledges
                              .where(
                                  (e) => e.currentUserLearning?.isDue == true)
                              .take(9)
                              .toList();

                          if (topKnowledges.isEmpty) {
                            return const SizedBox.shrink();
                          } else {
                            return Column(
                              children: [
                                Center(
                                  child: Text(
                                    "need_to_review".tr(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1,
                                  ),
                                  itemCount: topKnowledges.length,
                                  itemBuilder: (context, index) {
                                    var knowledge = topKnowledges[index];
                                    return Card(
                                      color:
                                          AppColors.secondary.withOpacity(0.7),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                            knowledge.title,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.success.withOpacity(0.7),
                                  ),
                                  onPressed: () => Navigator.push(
                                      context,
                                      ReviewKnowledgeScreen.route(
                                          knowledgeIds: topKnowledges
                                              .map((e) => e.id)
                                              .toList())),
                                  child: Text(
                                      "${"review".tr()} (${topKnowledges.length})"),
                                ),
                                const SpacedDivider(spacing: 4),
                              ],
                            );
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    ListTile(
                      title: Text("start_migration".tr()),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () =>
                          Navigator.push(context, MigrationScreen.route()),
                    ),
                    const SpacedDivider(spacing: 4),
                    ListTile(
                      title: Text("your_learning_lists".tr()),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => LearningListsScreen.navigate(),
                    ),
                    const SpacedDivider(spacing: 4),
                    ListTile(
                      title: Text("view_your_knowledges".tr()),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => Navigator.push(
                          context, CreatedKnowledgesScreen.route()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      autocorrect: false,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "enter_title".tr(),
                        labelText: "create_your_knowledge".tr(),
                        suffixIcon: const Icon(Icons.new_label),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSubmitted: (value) => Navigator.push(
                          context, CreateKnowledgeScreen.route(title: value)),
                    ),
                    const SizedBox(height: 16),
                    const SpacedDivider(spacing: 4),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              sliver: HomeListTracks(),
            ),
          ],
        ),
      ),
    );
  }
}
