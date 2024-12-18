class KnowledgeTypesRequest {
  String? search;

  KnowledgeTypesRequest({
    this.search,
  });

  Map<String, dynamic> toJson() {
    return {
      'search': search,
    };
  }
}
