import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learn_and_review/blocs/game_bloc.dart';

import 'status_bar.dart';

class PlayingHeader extends StatelessWidget {
  final GameInProgress state;

  const PlayingHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () async {
            bool? confirm = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('confirm'.tr()),
                  content: Text('are_you_sure_to_cancel'.tr()),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('no'.tr()),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('yes'.tr()),
                    ),
                  ],
                );
              },
            );
            if (confirm == true) {
              context.read<GameBloc>().add(EndGameRequested());
            }
          },
        ),
        const Expanded(child: StatusBar()),
        const SizedBox(width: 16),
      ],
    );
  }
}
