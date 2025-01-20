class MigrateRequest {
  final List<String> knowledgeIds;

  MigrateRequest({required this.knowledgeIds});

  Map<String, dynamic> toJson() {
    return {
      'knowledgeIds': knowledgeIds,
    };
  }
}
