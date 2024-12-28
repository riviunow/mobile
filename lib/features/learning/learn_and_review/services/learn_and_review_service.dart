import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

import '../models/review_learning.dart';
import '../models/get_to_learn.dart';
import '../models/learn_knowledge.dart';
import '../models/get_to_review.dart';

class LearnAndReviewService extends ApiService {
  ApiResponse<List<List<Knowledge>>> getKnowledgeToLearn(
      GetKnowledgesToLearnRequest request) {
    return postList(
        HttpRoute.getKnowledgesToLearn,
        (e) => (e as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => Knowledge.fromJson(e))
            .toList(),
        request.toJson());
  }

  ApiResponse<List<Learning>> learnKnowledge(LearnKnowledgeRequest request) {
    return postList(HttpRoute.learnKnowledge, (e) => Learning.fromJson(e),
        request.toJson());
  }

  ApiResponse<List<List<Learning>>> getLearningToReview(
      GetLearningToReviewRequest request) {
    return postList(
        HttpRoute.getLearningsToReview,
        (e) => (e as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => Learning.fromJson(e))
            .toList(),
        request.toJson());
  }

  ApiResponse<List<Learning>> reviewLearning(ReviewLearningRequest request) {
    return postList(HttpRoute.reviewLearning, (e) => Learning.fromJson(e),
        request.toJson());
  }
}
