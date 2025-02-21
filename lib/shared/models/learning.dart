part of 'index.dart';

class Learning extends SingleIdPivotEntity {
  final String knowledgeId;
  final Knowledge? knowledge;
  final String userId;
  final User? user;
  final DateTime nextReviewDate;
  final List<LearningHistory> learningHistories;
  final LearningHistory? latestLearningHistory;
  final int? learningListCount;
  bool get isDue => nextReviewDate.isBefore(DateTime.now());

  Learning({
    required super.id,
    super.modifiedBy,
    super.modifiedAt,
    required super.createdAt,
    required this.knowledgeId,
    this.knowledge,
    required this.userId,
    this.user,
    required this.nextReviewDate,
    this.learningHistories = const [],
    this.latestLearningHistory,
    this.learningListCount,
  });

  factory Learning.fromJson(Map<String, dynamic> json) {
    return Learning(
      id: json['id'] as String,
      modifiedBy: json['modifiedBy'] as String?,
      modifiedAt: json['modifiedAt'] != null
          ? parseUtcDateTime(json['createdAt'] as String)
          : null,
      createdAt: parseUtcDateTime(json['createdAt'] as String),
      knowledgeId: json['knowledgeId'] as String,
      knowledge: json['knowledge'] != null
          ? Knowledge.fromJson(json['knowledge'] as Map<String, dynamic>)
          : null,
      userId: json['userId'] as String,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      nextReviewDate: parseUtcDateTime(json['nextReviewDate'] as String),
      learningHistories: (json['learningHistories'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => LearningHistory.fromJson(e))
              .toList() ??
          [],
      latestLearningHistory: json['latestLearningHistory'] != null
          ? LearningHistory.fromJson(
              json['latestLearningHistory'] as Map<String, dynamic>)
          : null,
      learningListCount: json['learningListCount'] as int?,
    );
  }

  Learning copyWith({
    String? id,
    String? modifiedBy,
    DateTime? modifiedAt,
    DateTime? createdAt,
    String? knowledgeId,
    Knowledge? knowledge,
    String? userId,
    User? user,
    DateTime? nextReviewDate,
    List<LearningHistory>? learningHistories,
    LearningHistory? latestLearningHistory,
    int? learningListCount,
  }) {
    return Learning(
      id: id ?? this.id,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      createdAt: createdAt ?? this.createdAt,
      knowledgeId: knowledgeId ?? this.knowledgeId,
      knowledge: knowledge ?? this.knowledge,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      learningHistories: learningHistories ?? this.learningHistories,
      latestLearningHistory:
          latestLearningHistory ?? this.latestLearningHistory,
      learningListCount: learningListCount ?? this.learningListCount,
    );
  }

  flutter_material.Widget reviewCountDown({double fontSize = 14}) {
    final nowUtc = DateTime.now().toUtc();
    final difference = nextReviewDate.difference(nowUtc);

    if (difference.isNegative) {
      return flutter_material.Text('ready_to_review'.tr());
    }

    CountDownTimerFormat format;
    if (difference.inDays > 0) {
      format = CountDownTimerFormat.daysHoursMinutesSeconds;
    } else if (difference.inHours > 0) {
      format = CountDownTimerFormat.hoursMinutesSeconds;
    } else if (difference.inMinutes > 0) {
      format = CountDownTimerFormat.minutesSeconds;
    } else {
      format = CountDownTimerFormat.secondsOnly;
    }

    return TimerCountdown(
      format: format,
      endTime: nextReviewDate,
      hoursDescription: 'hours'.tr(),
      minutesDescription: 'minutes'.tr(),
      secondsDescription: 'seconds'.tr(),
      daysDescription: 'days'.tr(),
      timeTextStyle: flutter_material.TextStyle(
        fontSize: fontSize,
      ),
      descriptionTextStyle: flutter_material.TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}
