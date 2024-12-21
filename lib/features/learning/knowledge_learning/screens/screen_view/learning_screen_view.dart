import 'package:flutter/material.dart';
import 'package:udetxen/features/learning/knowledge_learning/screens/current_user_learning_screen.dart';
import 'package:udetxen/features/learning/knowledge_learning/screens/unlisted_learning_screen.dart';
import 'package:udetxen/features/learning/learning_list/screens/learning_lists_screen.dart';
import 'package:udetxen/shared/config/service_locator.dart';
import 'package:udetxen/shared/widgets/layouts/authenticated_layout.dart';

class LearningScreenView extends StatefulWidget {
  final ValueNotifier<AuthenticatedLayoutSettings> layoutSettings;

  static route(int index) {
    return MaterialPageRoute<void>(
      builder: (_) => getInstance(index),
    );
  }

  static Widget getInstance(int index) {
    getIt<ValueNotifier<AuthenticatedLayoutSettings>>().value =
        getIt<ValueNotifier<AuthenticatedLayoutSettings>>()
            .value
            .copyWith(initialIndex: 2, initialLearningListIndex: index);
    return getIt<AuthenticatedLayout>();
  }

  const LearningScreenView({super.key, required this.layoutSettings});

  @override
  State<LearningScreenView> createState() => _LearningScreenViewState();
}

class _LearningScreenViewState extends State<LearningScreenView> {
  @override
  void initState() {
    super.initState();
    widget.layoutSettings.addListener(_onIndexChanged);
  }

  @override
  void dispose() {
    widget.layoutSettings.removeListener(_onIndexChanged);
    super.dispose();
  }

  void _onIndexChanged() {
    setState(() {});
  }

  void _onItemTapped(int index) {
    widget.layoutSettings.value = widget.layoutSettings.value.copyWith(
      initialLearningListIndex: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.layoutSettings.value.initialLearningListIndex,
        children: const [
          LearningsScreen(),
          LearningListsScreen(),
          UnlistedLearningsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.layoutSettings.value.initialLearningListIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Learning Lists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.unpublished),
            label: 'Unlisted Learnings',
          ),
        ],
      ),
    );
  }
}
