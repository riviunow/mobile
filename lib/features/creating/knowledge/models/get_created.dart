class GetCreatedKnowledgesRequest {
  final String? search;
  final int page;
  final int pageSize;

  GetCreatedKnowledgesRequest({
    this.search,
    this.page = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      'search': search,
      'page': page,
      'pageSize': pageSize,
    };
  }

  GetCreatedKnowledgesRequest copyWith({
    String? search,
    int? page,
    int? pageSize,
  }) {
    return GetCreatedKnowledgesRequest(
      search: search ?? this.search,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
