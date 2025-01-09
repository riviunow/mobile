import 'package:easy_localization/easy_localization.dart';

enum LearningLevel {
  levelZero,
  levelOne,
  levelTwo,
  levelThree,
  levelFour,
  levelFive,
}

extension LearningLevelExtension on LearningLevel {
  static LearningLevel fromJson(String json) {
    switch (json) {
      case 'LevelZero':
        return LearningLevel.levelZero;
      case 'LevelOne':
        return LearningLevel.levelOne;
      case 'LevelTwo':
        return LearningLevel.levelTwo;
      case 'LevelThree':
        return LearningLevel.levelThree;
      case 'LevelFour':
        return LearningLevel.levelFour;
      case 'LevelFive':
        return LearningLevel.levelFive;
      default:
        throw ArgumentError('Unknown learning level: $json');
    }
  }

  String toJson() {
    switch (this) {
      case LearningLevel.levelZero:
        return 'LevelZero';
      case LearningLevel.levelOne:
        return 'LevelOne';
      case LearningLevel.levelTwo:
        return 'LevelTwo';
      case LearningLevel.levelThree:
        return 'LevelThree';
      case LearningLevel.levelFour:
        return 'LevelFour';
      case LearningLevel.levelFive:
        return 'LevelFive';
    }
  }

  String toStr() {
    switch (this) {
      case LearningLevel.levelZero:
        return 'learning_level.levelZero'.tr();
      case LearningLevel.levelOne:
        return 'learning_level.levelOne'.tr();
      case LearningLevel.levelTwo:
        return 'learning_level.levelTwo'.tr();
      case LearningLevel.levelThree:
        return 'learning_level.levelThree'.tr();
      case LearningLevel.levelFour:
        return 'learning_level.levelFour'.tr();
      case LearningLevel.levelFive:
        return 'learning_level.levelFive'.tr();
    }
  }
}
