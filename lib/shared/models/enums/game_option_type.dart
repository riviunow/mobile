import 'package:easy_localization/easy_localization.dart';

enum GameOptionType {
  question,
  answer,
}

extension GameOptionTypeExtension on GameOptionType {
  static GameOptionType fromJson(String json) {
    switch (json) {
      case 'Question':
        return GameOptionType.question;
      case 'Answer':
        return GameOptionType.answer;
      default:
        throw ArgumentError('Unknown game option type: $json');
    }
  }

  String toJson() {
    switch (this) {
      case GameOptionType.question:
        return 'Question';
      case GameOptionType.answer:
        return 'Answer';
    }
  }

  String toStr() {
    switch (this) {
      case GameOptionType.question:
        return 'game_option_type.question'.tr();
      case GameOptionType.answer:
        return 'game_option_type.answer'.tr();
    }
  }
}
