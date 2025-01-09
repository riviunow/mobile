enum OrderByType {
  Date,
  Title,
}

class SearchKnowledgesRequest {
  String? searchTerm;
  int page;
  int pageSize;
  List<String>? knowledgeTypeIds;
  List<String>? knowledgeTopicIds;
  String? level;
  OrderByType orderBy;
  bool? ascending;

  SearchKnowledgesRequest({
    this.searchTerm,
    this.page = 1,
    this.pageSize = 10,
    this.knowledgeTypeIds,
    this.knowledgeTopicIds,
    this.level,
    this.orderBy = OrderByType.Title,
    this.ascending,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchTerm': searchTerm,
      'page': page,
      'pageSize': pageSize,
      'knowledgeTypeIds': knowledgeTypeIds,
      'knowledgeTopicIds': knowledgeTopicIds,
      'level': level,
      'orderBy': orderBy.toString().split('.').last,
      'ascending': ascending,
    };
  }

  SearchKnowledgesRequest copyWith({
    String? searchTerm,
    int? page,
    int? pageSize,
    List<String>? knowledgeTypeIds,
    List<String>? knowledgeTopicIds,
    String? level,
    OrderByType? orderBy,
    bool? ascending,
  }) {
    return SearchKnowledgesRequest(
      searchTerm: searchTerm ?? this.searchTerm,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      knowledgeTypeIds: knowledgeTypeIds ?? this.knowledgeTypeIds,
      knowledgeTopicIds: knowledgeTopicIds ?? this.knowledgeTopicIds,
      level: level ?? this.level,
      orderBy: orderBy ?? this.orderBy,
      ascending: ascending ?? this.ascending,
    );
  }
}
