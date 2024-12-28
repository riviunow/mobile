import 'package:flutter/material.dart';
import 'package:udetxen/features/exploring/subject/screens/subject_detail_screen.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/index.dart';

class TrackDetailListSubjects extends StatelessWidget {
  final Track track;

  const TrackDetailListSubjects({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: track.trackSubjects.length,
      itemBuilder: (context, index) {
        final trackName = track.name;
        final subject = track.trackSubjects[index].subject;
        final totalKnowledge = subject?.knowledgeCount ?? 0;
        final userLearning = subject?.userLearningCount ?? 0;
        final percentage =
            totalKnowledge == 0 ? 0 : userLearning / totalKnowledge;

        Color getProgressColor(double percentage) {
          if (percentage == 0) {
            return AppColors.hint;
          } else if (percentage < 1) {
            return AppColors.warning;
          } else {
            return AppColors.success;
          }
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              SubjectDetailScreen.route(
                  subject: subject!, trackName: trackName),
            ),
            title: Text(subject?.name ?? 'Unknown Subject'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject?.description ?? 'No description available'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage.toDouble(),
                  color: getProgressColor(percentage.toDouble()),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (percentage == 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            SubjectDetailScreen.route(
                                subject: subject!,
                                learnAllKnowledge: true,
                                trackName: trackName),
                          ),
                          child: const Text('Learn'),
                        ),
                      )
                    else if (percentage < 1)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle continue learning action
                          },
                          child: Text(
                              'Continue Learning (${(percentage * 100).toStringAsFixed(1)}%)'),
                        ),
                      )
                    else
                      const Text('Completed'),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
