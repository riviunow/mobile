import 'package:flutter/material.dart';
import 'package:udetxen/features/exploring/knowledge/screens/search_knowledge_screen.dart';
import 'package:udetxen/features/exploring/track/screens/home_screen.dart';
import 'package:udetxen/features/profile/screens/profile_screen.dart';
import 'package:udetxen/features/learning/knowledge_learning/screens/screen_view/learning_screen_view.dart';

class AuthenticatedLayout extends StatefulWidget {
  final ValueNotifier<(int, int)> currentIndexNotifier;

  const AuthenticatedLayout({super.key, required this.currentIndexNotifier});

  @override
  State<AuthenticatedLayout> createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  late final List<Widget> _userScreens;

  @override
  void initState() {
    super.initState();
    widget.currentIndexNotifier.addListener(_onIndexChanged);
    _userScreens = [
      const HomeScreen(),
      const SearchKnowledgeScreen(),
      LearningScreenView(
        currentIndexNotifier: widget.currentIndexNotifier,
      ),
      const ProfileScreen(),
    ];
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
        (index, widget.currentIndexNotifier.value.$2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.currentIndexNotifier.value.$1,
        children: _userScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndexNotifier.value.$1,
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
