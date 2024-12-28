import 'package:flutter/material.dart';

class TrackDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String trackName;
  final String trackDescription;

  const TrackDetailAppBar({
    super.key,
    required this.trackName,
    required this.trackDescription,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trackName,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            trackDescription,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 4,
    );
  }
}
