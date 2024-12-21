import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/models/index.dart';
import 'package:udetxen/shared/services/api_service.dart';
import 'package:udetxen/shared/types/index.dart';

import '../models/update_learning_list.dart';
import '../models/create_learning_list.dart';
import '../models/add_remove_knowledge.dart';

class LearningListService extends ApiService {
  ApiResponse<LearningList> create(CreateLearningListRequest request) {
    return post<LearningList>(
        HttpRoute.createLearningList, LearningList.fromJson, request.toJson());
  }

  ApiResponse<LearningList> update(UpdateLearningListRequest request) {
    return post<LearningList>(
        HttpRoute.updateLearningList, LearningList.fromJson, request.toJson());
  }

  ApiResponse<LearningList> remove(String id) {
    return delete<LearningList>(
        HttpRoute.deleteLearningList(id), LearningList.fromJson, null);
  }

  ApiResponse<LearningList> getLearningList(String id) {
    return get<LearningList>(
        HttpRoute.getLearningListByGuid(id), LearningList.fromJson);
  }

  ApiResponse<List<LearningList>> getLearningLists() {
    return getList(
        HttpRoute.getAllLearningLists, (item) => LearningList.fromJson(item));
  }

  ApiResponse<LearningListKnowledge> addRemoveKnowledge(
      AddRemoveKnowledgeRequest request) {
    return post<LearningListKnowledge>(
        HttpRoute.addRemoveKnowledgeToLearningList,
        LearningListKnowledge.fromJson,
        request.toJson());
  }
}
