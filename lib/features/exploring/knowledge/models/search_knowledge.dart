import 'package:rvnow/shared/models/enums/knowledge_level.dart';

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
  KnowledgeLevel? level;
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
    this.ascending = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchTerm': searchTerm?.trim(),
      'page': page,
      'pageSize': pageSize,
      'knowledgeTypeIds': knowledgeTypeIds,
      'knowledgeTopicIds': knowledgeTopicIds,
      'level': level?.toJson(),
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
    KnowledgeLevel? level,
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

  SearchKnowledgesRequest clear() {
    return SearchKnowledgesRequest();
  }

  SearchKnowledgesRequest clearFilter({String? searchTerm, int? page}) {
    return SearchKnowledgesRequest(
      searchTerm: searchTerm ?? this.searchTerm,
      page: page ?? this.page,
      pageSize: pageSize,
      knowledgeTypeIds: [],
      knowledgeTopicIds: [],
      level: null,
      orderBy: OrderByType.Title,
      ascending: true,
    );
  }

  bool get hasFilters =>
      (knowledgeTypeIds != null && knowledgeTypeIds!.isNotEmpty) ||
      (knowledgeTopicIds != null && knowledgeTopicIds!.isNotEmpty) ||
      level != null ||
      orderBy != OrderByType.Title ||
      ascending != true;

  bool hasSimilarFilter(SearchKnowledgesRequest other) {
    return _listEquals(knowledgeTypeIds, other.knowledgeTypeIds) &&
        _listEquals(knowledgeTopicIds, other.knowledgeTopicIds) &&
        level == other.level &&
        orderBy == other.orderBy &&
        ascending == other.ascending;
  }

  bool _listEquals(List<String>? list1, List<String>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
