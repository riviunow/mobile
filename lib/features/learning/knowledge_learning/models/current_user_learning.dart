import 'package:rvnow/shared/models/enums/learning_level.dart';

class GetCurrentUserLearningRequest {
  final String? search;
  final int? page;
  final int? pageSize;
  final LearningLevel? learningLevel;

  GetCurrentUserLearningRequest({
    this.search,
    this.page,
    this.pageSize,
    this.learningLevel,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (search != null) data['search'] = search;
    if (page != null) data['page'] = page;
    if (pageSize != null) data['pageSize'] = pageSize;
    if (learningLevel != null) {
      data['learningLevel'] = learningLevel?.toJson();
    }
    return data;
  }
}
