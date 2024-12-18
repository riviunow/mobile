part of 'index.dart';

class LearningHistory extends SingleIdEntity {
  final String learningId;
  final Learning? learning;
  final String learningLevel;
  final bool isMemorized;
  final String playedGameId;
  final Game? playedGame;
  final int score;

  LearningHistory({
    required super.id,
    required super.createdAt,
    required this.learningId,
    this.learning,
    required this.learningLevel,
    required this.isMemorized,
    required this.playedGameId,
    this.playedGame,
    required this.score,
  });

  factory LearningHistory.fromJson(Map<String, dynamic> json) {
    return LearningHistory(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      learningId: json['learningId'],
      learning:
          json['learning'] != null ? Learning.fromJson(json['learning']) : null,
      learningLevel: json['learningLevel'],
      isMemorized: json['isMemorized'],
      playedGameId: json['playedGameId'],
      playedGame:
          json['playedGame'] != null ? Game.fromJson(json['playedGame']) : null,
      score: json['score'],
    );
  }

  LearningHistory copyWith({
    String? id,
    DateTime? createdAt,
    String? learningId,
    Learning? learning,
    String? learningLevel,
    bool? isMemorized,
    String? playedGameId,
    Game? playedGame,
    int? score,
  }) {
    return LearningHistory(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      learningId: learningId ?? this.learningId,
      learning: learning ?? this.learning,
      learningLevel: learningLevel ?? this.learningLevel,
      isMemorized: isMemorized ?? this.isMemorized,
      playedGameId: playedGameId ?? this.playedGameId,
      playedGame: playedGame ?? this.playedGame,
      score: score ?? this.score,
    );
  }
}
