import 'package:flutter/material.dart';
import 'package:udetxen/features/learning/knowledge_learning/screens/current_user_learning_screen.dart';
import 'package:udetxen/features/learning/knowledge_learning/screens/unlisted_learning_screen.dart';
import 'package:udetxen/features/learning/learning_list/screens/learning_list_screen.dart';
import 'package:udetxen/shared/config/service_locator.dart';
import 'package:udetxen/shared/widgets/layouts/authenticated_layout.dart';

class LearningScreenView extends StatefulWidget {
  final ValueNotifier<(int, int)> currentIndexNotifier;

  static route(int index) {
    return MaterialPageRoute<void>(
      builder: (_) => getInstance(index),
    );
  }

  static Widget getInstance(int index) {
    getIt<ValueNotifier<(int, int)>>().value = (2, index);
    return getIt<AuthenticatedLayout>();
  }

  const LearningScreenView({super.key, required this.currentIndexNotifier});

  @override
  State<LearningScreenView> createState() => _LearningScreenViewState();
}

class _LearningScreenViewState extends State<LearningScreenView> {
  @override
  void initState() {
    super.initState();
    widget.currentIndexNotifier.addListener(_onIndexChanged);
  }

  @override
  void dispose() {
    widget.currentIndexNotifier.removeListener(_onIndexChanged);
    super.dispose();
  }

  void _onIndexChanged() {
    setState(() {});
  }

  void _onItemTapped(int index) {
    widget.currentIndexNotifier.value =
        (widget.currentIndexNotifier.value.$1, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.currentIndexNotifier.value.$2,
        children: const [
          LearningsScreen(),
          LearningListScreen(),
          UnlistedLearningsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndexNotifier.value.$2,
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
