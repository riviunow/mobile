import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/game_bloc.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameInProgress) {
          final gameBloc = context.read<GameBloc>();
          final percentage =
              (gameBloc.currentKnowledge - 1) / gameBloc.totalKnowledges;
          return LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          );
        }
        return const SizedBox(height: 4);
      },
    );
  }
}
