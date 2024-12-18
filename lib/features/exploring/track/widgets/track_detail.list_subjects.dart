import 'package:flutter/material.dart';
import 'package:udetxen/features/exploring/subject/screens/subject_detail_screen.dart';
import 'package:udetxen/shared/config/theme/colors.dart';
import 'package:udetxen/shared/models/index.dart';

class TrackDetailListSubjects extends StatelessWidget {
  final List<TrackSubject> trackSubjects;

  const TrackDetailListSubjects({super.key, required this.trackSubjects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trackSubjects.length,
      itemBuilder: (context, index) {
        final subject = trackSubjects[index].subject;
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
            onTap: () {
              if (subject == null) return;
              Navigator.push(
                context,
                SubjectDetailScreen.route(subject: subject),
              );
            },
            title: Text(subject?.name ?? 'Unknown Subject'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject?.description ?? 'No description available'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage as double,
                  color: getProgressColor(percentage),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (percentage == 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle learn action
                          },
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
