import 'package:rvnow/shared/constants/http_route.dart';
import 'package:rvnow/shared/models/index.dart';
import 'package:rvnow/shared/services/api_service.dart';
import 'package:rvnow/shared/types/index.dart';

import '../models/update_learning_list.dart';
import '../models/create_learning_list.dart';
import '../models/add_remove_knowledges.dart';

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

  ApiResponse<List<LearningListKnowledge>> addRemoveKnowledges(
      AddRemoveKnowledgesRequest request) {
    return postList<LearningListKnowledge>(
        HttpRoute.addRemoveKnowledgesToLearningList,
        (e) => LearningListKnowledge.fromJson(e),
        request.toJson());
  }
}
