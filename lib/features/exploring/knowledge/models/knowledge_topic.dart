class KnowledgeTopicsRequest {
  String? search;

  KnowledgeTopicsRequest({
    this.search,
  });

  Map<String, dynamic> toJson() {
    return {
      'search': search,
    };
  }
}
