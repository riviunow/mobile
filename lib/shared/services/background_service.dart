import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:rvnow/shared/constants/urls.dart';
import 'package:rvnow/shared/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:sqflite/sqflite.dart';
import 'package:background_fetch/background_fetch.dart';

import '../constants/pref_keys.dart';
import '../models/enums/knowledge_level.dart';
import '../models/enums/learning_level.dart';
import '../models/index.dart';

const Map<LearningLevel, double> retentionMap = {
  LearningLevel.levelZero: 1,
  LearningLevel.levelOne: 24,
  LearningLevel.levelTwo: 120,
  LearningLevel.levelThree: 336,
  LearningLevel.levelFour: 720,
  LearningLevel.levelFive: 2160,
};

const Map<KnowledgeLevel, double> difficultyMap = {
  KnowledgeLevel.beginner: 1.2,
  KnowledgeLevel.intermediate: 1.0,
  KnowledgeLevel.expert: 0.8,
};

enum ForgettingLevel {
  levelOne,
  levelTwo,
  levelThree,
  levelFour,
  levelFive,
}

class BackgroundService {
  final NotificationService _notificationService;
  final SharedPreferences prefs;
  String? _userId;
  HubConnection? connection;

  BackgroundService(this._notificationService, this.prefs);

  Future<void> initialize() async {
    await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  @pragma('vm:entry-point')
  void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      BackgroundFetch.finish(taskId);
      return;
    }
    BackgroundFetch.finish(taskId);
  }

  Future<void> connectHubStartBackground(String userId, String token) async {
    if (connection != null) {
      return;
    }

    _userId ??= userId;

    connection = HubConnectionBuilder().withUrl("${Urls.baseUrl}/vocabhub",
        options: HttpConnectionOptions(
      accessTokenFactory: () async {
        var token = prefs.getString(PrefKeys.accessToken);
        return "Bearer $token";
      },
    )).build();

    connection!.on("SyncLearning", (message) async {
      if (message != null) {
        var learnings = ((message as List).first as List)
            .map((e) => Learning.fromJson(e as Map<String, dynamic>))
            .toList();

        await _saveLearningsToLocalDB(learnings, userId);
      }
    });

    await connection!.start()?.then((_) async {
      final db = await openDatabase('learning.db');

      bool isUserTableExist = await db
          .rawQuery(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='${_getLearningTableName(userId)}';")
          .then((value) => value.isNotEmpty);

      await connection!
          .invoke("OnUserConnected", args: [userId, isUserTableExist]);
    }).catchError((error) {
      // print("SignalR Connection Error: $error");
    });

    _startBackgroundFetch(userId);
  }

  Future<void> disconnectHub(String? userId) async {
    await connection?.invoke("OnUserDisconnected", args: [userId ?? ""]);
    connection = null;
    _userId = null;
  }

  Future<void> stopBackgroundFetch() async {
    await BackgroundFetch.stop("com.transistorsoft.notification");
  }

  Future<void> updateLearnings(List<Learning> learnings) async {
    if (_userId == null) return;

    final db = await openDatabase('learning.db');
    final tableName = _getLearningTableName(_userId!);

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      title TEXT,
      difficulty TEXT,
      nextReviewDate INTEGER,
      level TEXT
    )
    ''');

    for (var learning in learnings) {
      await db.insert(
        tableName,
        {
          'id': learning.id,
          'title': learning.knowledge?.title,
          'difficulty': learning.knowledge?.level.toJson(),
          'nextReviewDate': learning.nextReviewDate.millisecondsSinceEpoch,
          'level': learning.latestLearningHistory?.learningLevel.toJson(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> _startBackgroundFetch(String userId) async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
      ),
      (String taskId) async {
        // print("BackgroundFetch task: $taskId");
        _checkAndSendNotifications(userId);
        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        // print("BackgroundFetch timeout: $taskId");
        BackgroundFetch.finish(taskId);
      },
    );

    await BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "com.transistorsoft.notification",
      delay: 60 * 60 * 1000,
      periodic: true,
      forceAlarmManager: true,
      stopOnTerminate: false,
      enableHeadless: true,
    ));
  }

  Future<void> _saveLearningsToLocalDB(
      List<Learning> learnings, String userId) async {
    final db = await openDatabase('learning.db');

    await db.execute('''
        CREATE TABLE IF NOT EXISTS ${_getLearningTableName(userId)} (
          id TEXT PRIMARY KEY,
          title TEXT,
          difficulty TEXT,
          nextReviewDate INTEGER,
          level TEXT
        )
      ''');

    for (var learning in learnings) {
      await db.insert(
        _getLearningTableName(userId),
        {
          'id': learning.id,
          'title': learning.knowledge?.title,
          'difficulty': learning.knowledge?.level.toJson(),
          'nextReviewDate': learning.nextReviewDate.millisecondsSinceEpoch,
          'level': learning.latestLearningHistory?.learningLevel.toJson(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> _checkAndSendNotifications(String userId) async {
    final db = await openDatabase('learning.db');
    await db.execute('''
        CREATE TABLE IF NOT EXISTS ${_getLearningTableName(userId)} (
          id TEXT PRIMARY KEY,
          title TEXT,
          difficulty TEXT,
          nextReviewDate INTEGER,
          level TEXT
        )
      ''');
    await db.execute('''
        CREATE TABLE IF NOT EXISTS ${_getNotificationTableName(userId)} (
          level INTEGER PRIMARY KEY,
          timestamp INTEGER
        )
      ''');

    final List<Map<String, dynamic>> learnings =
        await db.query(_getLearningTableName(userId));
    final now = DateTime.now().toUtc();

    Map<ForgettingLevel, List<String>> learningsMap = {
      for (var level in ForgettingLevel.values) level: [],
    };

    for (var learning in learnings) {
      final level = LearningLevelExtension.fromJson(learning['level']);
      final nextReview =
          DateTime.fromMillisecondsSinceEpoch(learning['nextReviewDate']);
      final difficulty =
          KnowledgeLevelExtension.fromJson(learning['difficulty']);

      double retentionScore =
          _calculateRetentionScore(nextReview, level, difficulty);

      if (retentionScore < 0.2) {
        learningsMap[ForgettingLevel.levelFive]?.add(learning['title']);
      } else if (retentionScore < 0.4) {
        learningsMap[ForgettingLevel.levelFour]?.add(learning['title']);
      } else if (retentionScore < 0.6) {
        learningsMap[ForgettingLevel.levelThree]?.add(learning['title']);
      } else if (retentionScore < 0.8) {
        learningsMap[ForgettingLevel.levelTwo]?.add(learning['title']);
      } else {
        learningsMap[ForgettingLevel.levelOne]?.add(learning['title']);
      }
    }

    final List<Map<String, dynamic>> lastNotifiedTimes =
        await db.query(_getNotificationTableName(userId));
    Map<ForgettingLevel, DateTime> lastNotifiedMap = {};

    for (var row in lastNotifiedTimes) {
      lastNotifiedMap[ForgettingLevel.values
              .firstWhere((e) => e.index == row['level'] as int)] =
          DateTime.fromMillisecondsSinceEpoch(row['timestamp'] as int);
    }

    Future<void> sendNotificationIfNeeded(
        ForgettingLevel level, Duration minInterval) async {
      if (learningsMap[level]!.isNotEmpty) {
        DateTime? lastNotified = lastNotifiedMap[level];

        if (lastNotified != null &&
            now.difference(lastNotified) >= minInterval) {
          await _notificationService.showNotification(
            title: _getReminderMsg(level),
            body: learningsMap[level]!.map((e) => '- $e').join('\n'),
          );
        }
        await db.insert(
            _getNotificationTableName(userId),
            {
              'level': level.index,
              'timestamp': now.millisecondsSinceEpoch,
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    await sendNotificationIfNeeded(ForgettingLevel.levelFive, Duration.zero);
    await sendNotificationIfNeeded(
        ForgettingLevel.levelFour, const Duration(hours: 3));
    await sendNotificationIfNeeded(
        ForgettingLevel.levelThree, const Duration(hours: 10));
    await sendNotificationIfNeeded(
        ForgettingLevel.levelTwo, const Duration(days: 1));
    await sendNotificationIfNeeded(
        ForgettingLevel.levelOne, const Duration(days: 3));
  }

  double _calculateRetentionScore(
      DateTime nextReview, LearningLevel level, KnowledgeLevel difficulty) {
    final now = DateTime.now().toUtc();
    final elapsedHours = now.difference(nextReview).inHours.toDouble();

    if (elapsedHours <= 0) return 1.0;

    double T = retentionMap[level] ?? 10;
    double D = difficultyMap[difficulty] ?? 1.0;

    double forgettingScore = (elapsedHours / (T * D)).abs();
    return (forgettingScore > 1.0) ? 0.0 : (1 - forgettingScore);
  }

  String _getReminderMsg(ForgettingLevel level) {
    switch (level) {
      case ForgettingLevel.levelOne:
        return "It's time to review knowledge!".tr();
      case ForgettingLevel.levelTwo:
        return "Don't forget to review recent learnings.".tr();
      case ForgettingLevel.levelThree:
        return "Knowledge needs a quick refresh.".tr();
      case ForgettingLevel.levelFour:
        return "Consider revisiting studies soon.".tr();
      default:
        return "Urgent! Review knowledge immediately.".tr();
    }
  }

  String _getLearningTableName(String userId) {
    return "Learnings_$userId".replaceAll("-", "_");
  }

  String _getNotificationTableName(String userId) {
    return "Notifications_$userId".replaceAll("-", "_");
  }
}
