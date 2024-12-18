part of 'index.dart';

class Knowledge extends SingleIdEntity {
  final String title;
  final String visibility;
  final String level;
  final String creatorId;
  final User? creator;
  final PublicationRequest? publicationRequest;
  final List<Material> materials;
  final List<SubjectKnowledge> subjectKnowledges;
  final List<KnowledgeTypeKnowledge> knowledgeTypeKnowledges;
  final List<KnowledgeTopicKnowledge> knowledgeTopicKnowledges;
  final List<Learning> learnings;
  final List<GameKnowledgeSubscription> gameKnowledgeSubscriptions;
  final GameKnowledgeSubscription? gameToReview;
  final List<GameKnowledgeSubscription>? gamesToLearn;
  final List<LearningListKnowledge> learningListKnowledges;
  final Learning? currentUserLearning;

  Knowledge({
    required super.id,
    required super.createdAt,
    required this.title,
    required this.visibility,
    required this.level,
    required this.creatorId,
    this.creator,
    this.publicationRequest,
    this.materials = const [],
    this.subjectKnowledges = const [],
    this.knowledgeTypeKnowledges = const [],
    this.knowledgeTopicKnowledges = const [],
    this.learnings = const [],
    this.gameKnowledgeSubscriptions = const [],
    this.gameToReview,
    this.gamesToLearn,
    this.learningListKnowledges = const [],
    this.currentUserLearning,
  });

  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      visibility: json['visibility'],
      level: json['level'],
      creatorId: json['creatorId'],
      creator: json['creator'] != null ? User.fromJson(json['creator']) : null,
      publicationRequest: json['publicationRequest'] != null
          ? PublicationRequest.fromJson(json['publicationRequest'])
          : null,
      materials: (json['materials'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => Material.fromJson(e))
          .toList(),
      subjectKnowledges: (json['subjectKnowledges'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => SubjectKnowledge.fromJson(e))
          .toList(),
      knowledgeTypeKnowledges: (json['knowledgeTypeKnowledges'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => KnowledgeTypeKnowledge.fromJson(e))
          .toList(),
      knowledgeTopicKnowledges: (json['knowledgeTopicKnowledges'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => KnowledgeTopicKnowledge.fromJson(e))
          .toList(),
      learnings: (json['learnings'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => Learning.fromJson(e))
          .toList(),
      gameKnowledgeSubscriptions: (json['gameKnowledgeSubscriptions'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => GameKnowledgeSubscription.fromJson(e))
          .toList(),
      gameToReview: json['gameToReview'] != null
          ? GameKnowledgeSubscription.fromJson(json['gameToReview'])
          : null,
      gamesToLearn: json['gamesToLearn'] != null
          ? (json['gamesToLearn'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => GameKnowledgeSubscription.fromJson(e))
              .toList()
          : null,
      learningListKnowledges: (json['learningListKnowledges'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => LearningListKnowledge.fromJson(e))
          .toList(),
      currentUserLearning: json['currentUserLearning'] != null
          ? Learning.fromJson(json['currentUserLearning'])
          : null,
    );
  }

  Knowledge copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    String? visibility,
    String? level,
    String? creatorId,
    User? creator,
    PublicationRequest? publicationRequest,
    List<Material>? materials,
    List<SubjectKnowledge>? subjectKnowledges,
    List<KnowledgeTypeKnowledge>? knowledgeTypeKnowledges,
    List<KnowledgeTopicKnowledge>? knowledgeTopicKnowledges,
    List<Learning>? learnings,
    List<GameKnowledgeSubscription>? gameKnowledgeSubscriptions,
    GameKnowledgeSubscription? gameToReview,
    List<GameKnowledgeSubscription>? gamesToLearn,
    List<LearningListKnowledge>? learningListKnowledges,
    Learning? currentUserLearning,
  }) {
    return Knowledge(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      visibility: visibility ?? this.visibility,
      level: level ?? this.level,
      creatorId: creatorId ?? this.creatorId,
      creator: creator ?? this.creator,
      publicationRequest: publicationRequest ?? this.publicationRequest,
      materials: materials ?? this.materials,
      subjectKnowledges: subjectKnowledges ?? this.subjectKnowledges,
      knowledgeTypeKnowledges:
          knowledgeTypeKnowledges ?? this.knowledgeTypeKnowledges,
      knowledgeTopicKnowledges:
          knowledgeTopicKnowledges ?? this.knowledgeTopicKnowledges,
      learnings: learnings ?? this.learnings,
      gameKnowledgeSubscriptions:
          gameKnowledgeSubscriptions ?? this.gameKnowledgeSubscriptions,
      gameToReview: gameToReview ?? this.gameToReview,
      gamesToLearn: gamesToLearn ?? this.gamesToLearn,
      learningListKnowledges:
          learningListKnowledges ?? this.learningListKnowledges,
      currentUserLearning: currentUserLearning ?? this.currentUserLearning,
    );
  }
}
