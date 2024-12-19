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
}
