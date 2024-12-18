import 'package:flutter/material.dart';
import 'package:udetxen/features/exploring/track/widgets/home.app_bar.dart';
import 'package:udetxen/features/exploring/track/widgets/home.list_tracks.dart';
import 'package:udetxen/shared/widgets/layouts/authenticated_layout.dart';

class HomeScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute<void>(
      builder: (_) => getInstance(),
    );
  }

  static Widget getInstance() {
    return const AuthenticatedLayout();
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
              pinned: true,
              expandedHeight: 50.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: const FlexibleSpaceBar(
                background: HomeAppBar(),
              ),
            ),
            const SliverFillRemaining(
              child: HomeListTracks(),
            ),
          ],
        ),
      ),
    );
  }
}
