import 'package:flutter/material.dart';
import 'package:rvnow/features/exploring/knowledge/screens/search_knowledge_screen.dart';
import 'package:rvnow/features/exploring/track/screens/home_screen.dart';
import 'package:rvnow/features/profile/screens/profile_screen.dart';

class UnauthenticatedLayout extends StatefulWidget {
  static route() {
    return MaterialPageRoute<void>(
      builder: (_) => const UnauthenticatedLayout(),
    );
  }

  const UnauthenticatedLayout({super.key});

  @override
  State<UnauthenticatedLayout> createState() => _UnauthenticatedLayoutState();
}

class _UnauthenticatedLayoutState extends State<UnauthenticatedLayout> {
  final List<Widget> _userScreens = [
    const HomeScreen(),
    const SearchKnowledgeScreen(),
    const ProfileScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _userScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
