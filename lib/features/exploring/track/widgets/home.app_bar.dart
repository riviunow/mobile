import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/profile/screens/profile_screen.dart';
import '../../../../shared/constants/urls.dart';
import '../../../profile/bloc/profile_bloc.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, ProfileScreen.route());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage("${Urls.mediaUrl}/${state.user.photoUrl!}"),
                ),
                const SizedBox(width: 10),
                Text(state.user.userName, style: const TextStyle(fontSize: 20)),
                // Add more widgets here if needed
              ],
            ),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                child: Icon(Icons.person,
                    size: 20, color: Theme.of(context).primaryColor),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 100,
                height: 20,
              ),
            ],
          );
        }
      },
    );
  }
}
