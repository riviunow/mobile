import 'package:flutter/material.dart';
import 'package:udetxen/features/exploring/knowledge/screens/search_knowledge_screen.dart';
import 'package:udetxen/features/exploring/track/screens/home_screen.dart';
import 'package:udetxen/features/profile/screens/profile_screen.dart';

class AuthenticatedLayout extends StatefulWidget {
  final int currentIndex;

  const AuthenticatedLayout({super.key, this.currentIndex = 0});

  @override
  State<AuthenticatedLayout> createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  late int _selectedIndex;

  final List<Widget> _userScreens = [
    const HomeScreen(),
    const SearchKnowledgeScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userScreens[_selectedIndex],
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
