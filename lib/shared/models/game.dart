part of 'index.dart';

class Game extends SingleIdEntity {
  final String name;
  final String description;
  final String imageUrl;
  final List<GameKnowledgeSubscription> gameKnowledgeSubscriptions;

  Game({
    required super.id,
    required super.createdAt,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.gameKnowledgeSubscriptions = const [],
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      createdAt: parseUtcDateTime(json['createdAt'] as String),
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      gameKnowledgeSubscriptions:
          (json['gameKnowledgeSubscriptions'] as List<dynamic>?)
                  ?.whereType<Map<String, dynamic>>()
                  .map((e) => GameKnowledgeSubscription.fromJson(e))
                  .toList() ??
              [],
    );
  }

  Game copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? description,
    String? imageUrl,
    List<GameKnowledgeSubscription>? gameKnowledgeSubscriptions,
  }) {
    return Game(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      gameKnowledgeSubscriptions:
          gameKnowledgeSubscriptions ?? this.gameKnowledgeSubscriptions,
    );
  }
}
