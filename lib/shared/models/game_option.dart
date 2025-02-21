part of 'index.dart';

class GameOption extends SingleIdEntity {
  final String gameKnowledgeSubscriptionId;
  final GameKnowledgeSubscription? gameKnowledgeSubscription;
  final GameOptionType type;
  final String value;
  final int group;
  final bool? isCorrect;
  final int? order;

  GameOption({
    required super.id,
    required super.createdAt,
    required this.gameKnowledgeSubscriptionId,
    this.gameKnowledgeSubscription,
    required this.type,
    required this.value,
    required this.group,
    this.isCorrect,
    this.order,
  });

  factory GameOption.fromJson(Map<String, dynamic> json) {
    return GameOption(
      id: json['id'],
      createdAt: parseUtcDateTime(json['createdAt'] as String),
      gameKnowledgeSubscriptionId: json['gameKnowledgeSubscriptionId'],
      gameKnowledgeSubscription: json['gameKnowledgeSubscription'] != null
          ? GameKnowledgeSubscription.fromJson(
              json['gameKnowledgeSubscription'])
          : null,
      type: GameOptionTypeExtension.fromJson(json['type']),
      value: json['value'],
      group: json['group'],
      isCorrect: json['isCorrect'],
      order: json['order'],
    );
  }

  GameOption copyWith({
    String? id,
    DateTime? createdAt,
    String? gameKnowledgeSubscriptionId,
    GameKnowledgeSubscription? gameKnowledgeSubscription,
    GameOptionType? type,
    String? value,
    int? group,
    bool? isCorrect,
    int? order,
  }) {
    return GameOption(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      gameKnowledgeSubscriptionId:
          gameKnowledgeSubscriptionId ?? this.gameKnowledgeSubscriptionId,
      gameKnowledgeSubscription:
          gameKnowledgeSubscription ?? this.gameKnowledgeSubscription,
      type: type ?? this.type,
      value: value ?? this.value,
      group: group ?? this.group,
      isCorrect: isCorrect ?? this.isCorrect,
      order: order ?? this.order,
    );
  }
}
