import 'package:flutter/material.dart';
import 'package:rvnow/features/exploring/knowledge/screens/search_knowledge_screen.dart';
import 'package:rvnow/features/exploring/track/screens/home_screen.dart';
import 'package:rvnow/features/profile/screens/profile_screen.dart';
import 'package:rvnow/features/learning/knowledge_learning/screens/screen_view/learning_screen_view.dart';

class AuthenticatedLayoutSettings {
  final int initialIndex;
  final int initialLearningListIndex;

  const AuthenticatedLayoutSettings({
    this.initialIndex = 0,
    this.initialLearningListIndex = 0,
  });

  AuthenticatedLayoutSettings copyWith({
    int? initialIndex,
    int? initialLearningListIndex,
    bool? focusSearch,
  }) {
    return AuthenticatedLayoutSettings(
      initialIndex: initialIndex ?? this.initialIndex,
      initialLearningListIndex:
          initialLearningListIndex ?? this.initialLearningListIndex,
    );
  }
}

class AuthenticatedLayout extends StatefulWidget {
  final ValueNotifier<AuthenticatedLayoutSettings> layoutSettings;

  const AuthenticatedLayout({super.key, required this.layoutSettings});

  @override
  State<AuthenticatedLayout> createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  late final List<Widget> _userScreens;

  @override
  void initState() {
    super.initState();
    widget.layoutSettings.addListener(_onIndexChanged);
    _userScreens = [
      const HomeScreen(),
      const SearchKnowledgeScreen(),
      LearningScreenView(
        layoutSettings: widget.layoutSettings,
      ),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    widget.layoutSettings.removeListener(_onIndexChanged);
    super.dispose();
  }

  void _onIndexChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void _onItemTapped(int index) {
    widget.layoutSettings.value = widget.layoutSettings.value.copyWith(
      initialIndex: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.layoutSettings.value.initialIndex,
        children: _userScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.layoutSettings.value.initialIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
