import 'package:rvnow/shared/models/enums/learning_level.dart';

class GetCurrentUserLearningRequest {
  final String? search;
  final int page;
  final int pageSize;
  final LearningLevel? learningLevel;

  GetCurrentUserLearningRequest({
    this.search,
    this.page = 1,
    this.pageSize = 50,
    this.learningLevel,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (search != null) data['search'] = search;
    data['page'] = page;
    data['pageSize'] = pageSize;
    if (learningLevel != null) {
      data['learningLevel'] = learningLevel?.toJson();
    }
    return data;
  }

  GetCurrentUserLearningRequest copyWith({
    String? search,
    int? page,
    int? pageSize,
    LearningLevel? learningLevel,
  }) {
    return GetCurrentUserLearningRequest(
      search: search ?? this.search,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      learningLevel: learningLevel ?? this.learningLevel,
    );
  }
}
