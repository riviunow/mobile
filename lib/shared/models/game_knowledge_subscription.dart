part of 'index.dart';

class GameKnowledgeSubscription extends SingleIdPivotEntity {
  final String gameId;
  final Game? game;
  final String knowledgeId;
  final Knowledge? knowledge;
  final List<GameOption> gameOptions;
  GameOption get question => gameOptions
      .firstWhere((option) => option.type == GameOptionType.question);

  GameKnowledgeSubscription({
    required super.id,
    super.modifiedBy,
    super.modifiedAt,
    required super.createdAt,
    required this.gameId,
    this.game,
    required this.knowledgeId,
    this.knowledge,
    this.gameOptions = const [],
  });

  factory GameKnowledgeSubscription.fromJson(Map<String, dynamic> json) {
    return GameKnowledgeSubscription(
      id: json['id'],
      modifiedBy: json['modifiedBy'],
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      gameId: json['gameId'],
      game: json['game'] != null ? Game.fromJson(json['game']) : null,
      knowledgeId: json['knowledgeId'],
      knowledge: json['knowledge'] != null
          ? Knowledge.fromJson(json['knowledge'])
          : null,
      gameOptions: (json['gameOptions'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => GameOption.fromJson(e))
              .toList() ??
          [],
    );
  }

  GameKnowledgeSubscription copyWith({
    String? id,
    String? modifiedBy,
    DateTime? modifiedAt,
    DateTime? createdAt,
    String? gameId,
    Game? game,
    String? knowledgeId,
    Knowledge? knowledge,
    List<GameOption>? gameOptions,
  }) {
    return GameKnowledgeSubscription(
      id: id ?? this.id,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      createdAt: createdAt ?? this.createdAt,
      gameId: gameId ?? this.gameId,
      game: game ?? this.game,
      knowledgeId: knowledgeId ?? this.knowledgeId,
      knowledge: knowledge ?? this.knowledge,
      gameOptions: gameOptions ?? this.gameOptions,
    );
  }
}
