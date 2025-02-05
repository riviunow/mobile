import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/exploring/knowledge/widgets/learning_list_dialog.dart';
import 'package:rvnow/features/learning/learn_and_review/blocs/game_bloc.dart';
import 'package:rvnow/shared/config/theme/colors.dart';
import 'package:rvnow/shared/models/enums/learning_level.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/widgets/spaced_divider.dart';
import 'package:fl_chart/fl_chart.dart';

class GameOverBoard extends StatefulWidget {
  final List<Learning> learnings;

  const GameOverBoard({super.key, required this.learnings});

  @override
  State<GameOverBoard> createState() => _GameOverBoardState();
}

class _GameOverBoardState extends State<GameOverBoard> {
  final Set<Learning> _selectedLearnings = {};
  bool _isSelectionMode = false;

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedLearnings.clear();
      }
    });
  }

  void _onLearningSelected(Learning learning) {
    setState(() {
      if (_selectedLearnings.contains(learning)) {
        _selectedLearnings.remove(learning);
      } else {
        _selectedLearnings.add(learning);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      _selectedLearnings.isEmpty
          ? _selectedLearnings.addAll(widget.learnings
              .where((learning) => learning.learningListCount == 0))
          : _selectedLearnings.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final zeroLearningListCountLearnings = widget.learnings
        .where((learning) => learning.learningListCount == 0)
        .toList();
    final otherLearnings = widget.learnings
        .where((learning) => learning.learningListCount != 0)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'overall_result'.tr(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildOverallResult(),
                const SizedBox(height: 26),
                if (zeroLearningListCountLearnings.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'unlisted_learnings'.tr(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          if (!_isSelectionMode)
                            IconButton(
                              onPressed: _toggleSelectionMode,
                              icon: const Icon(Icons.select_all),
                            )
                          else ...[
                            IconButton(
                              onPressed: _toggleSelectAll,
                              icon: Icon(_selectedLearnings.length ==
                                      zeroLearningListCountLearnings.length
                                  ? Icons.check_box_outlined
                                  : Icons.check_box_outline_blank),
                            ),
                            IconButton(
                              onPressed: _toggleSelectionMode,
                              icon: const Icon(Icons.cancel),
                            ),
                          ]
                        ],
                      )
                    ],
                  ),
                  _buildLearningList(zeroLearningListCountLearnings,
                      isUnlisted: true),
                ],
                if (zeroLearningListCountLearnings.isNotEmpty &&
                    otherLearnings.isNotEmpty)
                  const SpacedDivider(spacing: 36),
                if (otherLearnings.isNotEmpty)
                  _buildLearningList(otherLearnings),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<GameBloc>().add(OutGameRequested());
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: AppColors.secondary.withOpacity(0.8),
                  ),
                  child: Text(
                    'finish'.tr(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                if (_isSelectionMode) ...[
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _selectedLearnings.isEmpty ||
                            !_selectedLearnings.every(
                              (l) => zeroLearningListCountLearnings
                                  .any((z) => z.id == l.id),
                            )
                        ? null
                        : () async {
                            var result = await Navigator.push(
                              context,
                              LearningListDialog.route(_selectedLearnings
                                  .map((e) => e.knowledgeId)
                                  .toList()),
                            );
                            _toggleSelectionMode();
                            if (result == true) {
                              context.read<GameBloc>().add(
                                    LearningListed(_selectedLearnings
                                        .map((e) => e.id)
                                        .toList()),
                                  );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.8),
                    ),
                    child: Text(
                      'add_to_list'.tr(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallResult() {
    int totalScore = 0;
    int memorizedCount = 0;

    for (var learning in widget.learnings) {
      final latestHistory = learning.latestLearningHistory;
      if (latestHistory != null) {
        totalScore += latestHistory.score;
        if (latestHistory.isMemorized) {
          memorizedCount++;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${"total_score".tr()}: $totalScore',
            style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${"memorized".tr()}: $memorizedCount / ${widget.learnings.length}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: memorizedCount.toDouble(),
                      color: Colors.green,
                      title:
                          '${(memorizedCount / widget.learnings.length * 100).toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value:
                          (widget.learnings.length - memorizedCount).toDouble(),
                      color: Colors.red,
                      title: '',
                      radius: 50,
                    ),
                  ],
                  centerSpaceRadius: 30,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLearningList(List<Learning> learnings,
      {bool isUnlisted = false}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: learnings.length,
      itemBuilder: (context, index) {
        final learning = learnings[index];
        final latestHistory = learning.latestLearningHistory;
        final isSelected =
            isUnlisted == false ? false : _selectedLearnings.contains(learning);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            onTap: _isSelectionMode && isUnlisted
                ? () => _onLearningSelected(learning)
                : null,
            title: Text(learning.knowledge?.title ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${"score".tr()}: ${latestHistory?.score ?? 'N/A'}'),
                Text(
                    '${"level".tr()}: ${latestHistory?.learningLevel.toStr() ?? 'N/A'}'),
                Text(
                    '${"memorized".tr()}: ${latestHistory?.isMemorized ?? 'N/A'}'),
                Text(learning.calculateTimeLeft()),
              ],
            ),
            trailing: _isSelectionMode
                ? Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isSelected ? Theme.of(context).primaryColor : null,
                  )
                : null,
          ),
        );
      },
    );
  }
}
