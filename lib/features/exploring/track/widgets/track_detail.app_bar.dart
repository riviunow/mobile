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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            trackDescription,
            style: TextStyle(
                color: Theme.of(context).hintColor.withOpacity(0.7),
                fontSize: 14),
          ),
        ],
      ),
      elevation: 4,
    );
  }
}
