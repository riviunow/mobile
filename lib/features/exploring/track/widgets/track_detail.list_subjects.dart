import 'package:easy_localization/easy_localization.dart';
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

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            SubjectDetailScreen.route(subject: subject!, trackName: trackName),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8.0),
              border: percentage == 1
                  ? Border.all(
                      color: AppColors.success.withOpacity(0.6),
                      width: 4,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject?.name ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                            const SizedBox(height: 8),
                            if (subject?.description != null) ...[
                              Text(
                                subject?.description ?? '',
                                style: TextStyle(
                                  color: AppColors.hint.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            Text(
                              '($totalKnowledge) ${"knowledges".tr()}',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (subject?.photo != null && subject!.photo.isNotEmpty)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(subject.photo),
                        )
                    ],
                  ),
                  if (percentage > 0 && percentage < 1) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percentage.toDouble(),
                      color: AppColors.warning,
                      backgroundColor: AppColors.hint.withOpacity(0.5),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: percentage < 1
                            ? ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  SubjectDetailScreen.route(
                                      subject: subject!,
                                      learnAllKnowledge: true,
                                      trackName: trackName),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text(
                                  percentage == 0
                                      ? 'learn'.tr()
                                      : '${"continue_learning".tr()} (${(percentage * 100).toStringAsFixed(1)}%)',
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'completed'.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
