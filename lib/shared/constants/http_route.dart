class HttpRoute {
  // JWT
  static const String refreshAccessToken = "jwt/refresh-access-token";

  // Auth
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String confirmRegistrationEmail =
      "auth/confirm-registration-email";
  static const String forgotPassword = "auth/forgot-password";
  static const String resendCode = "auth/resend-confirmation-code";
  static const String confirmPasswordResettingEmail =
      "auth/confirm-password-resetting-email";
  static const String logout = "auth/logout";

  // Profile
  static const String getProfile = "profile/get";
  static const String updateProfile = "profile/update";
  static const String deleteAccount = "profile/delete-account";

  // Track
  static const String getTracks = "track/list";
  static const String getDetailedTracks = "track/list-detailed";
  static String getTrackById(String id) => "track/detailed/$id";
  static const String createTrack = "track/create";
  static const String updateTrack = "track/update";
  static String deleteTrack(String id) => "delete/$id";
  static const String createDeleteTrackSubject = "track/add-remove-subject";

  // Subject
  static const String getSubjects = "subject/list";
  static String getSubjectById(String id) => "subject/detailed/$id";
  static const String createSubject = "subject/create";
  static const String updateSubject = "subject/update";
  static String deleteSubject(String id) => "delete/$id";
  static const String createDeleteSubjectKnowledge =
      "subject/add-remove-knowledge";

  // Knowledge
  static const String searchKnowledges = "knowledge/search";
  static const String getKnowledges = "knowledge/list";
  static const String getCreatedKnowledges = "knowledge/list-created";
  static String getDetailedKnowledgeByGuid(String id) =>
      "knowledge/detailed/$id";
  static const String createKnowledge = "knowledge/create";
  static const String updateKnowledge = "knowledge/update";
  static String deleteKnowledge(String id) => "knowledge/delete/$id";
  static String publishKnowledge(String id) => "knowledge/publish/$id";
  static const String getKnowledgesToLearn = "knowledge/to-learn";
  static const String migrate = "knowledge/migrate";

  // KnowledgeType
  static const String getKnowledgeTypes = "knowledgeType/list";
  static String getKnowledgeTypeByGuid(String id) =>
      "knowledgeType/detailed/$id";
  static const String createKnowledgeType = "knowledgeType/create";
  static const String updateKnowledgeType = "knowledgeType/update";
  static String deleteKnowledgeType(String id) => "knowledgeType/delete/$id";
  static const String attachDetachKnowledges =
      "knowledgeType/attach-detach-knowledges";

  // KnowledgeTopic
  static const String getKnowledgeTopics = "knowledgeTopic/list";
  static String getKnowledgeTopicByGuid(String id) =>
      "knowledgeTopic/detailed/$id";
  static const String createKnowledgeTopic = "knowledgeTopic/create";
  static const String updateKnowledgeTopic = "knowledgeTopic/update";
  static String deleteKnowledgeTopic(String id) => "knowledgeTopic/delete/$id";
  static String getTopicsForMigration =
      "knowledgeTopic/get-topics-for-migration";

  // Learning
  static const String learnKnowledge = "learning/learn";
  static const String getLearningsToReview = "learning/to-review";
  static const String reviewLearning = "learning/review";
  static const String getCurrentUserLearnings = "learning/get-learnings";
  static const String getUnlistedLearnings = "learning/get-unlisted-learnings";

  // Game
  static const String getGames = "list";
  static String getGameByGuid(String id) => "detailed/$id";
  static const String createGame = "create";
  static const String updateGame = "update";
  static String deleteGame(String id) => "delete/$id";
  static const String attachGameToKnowledge = "attach-to-knowledge";

  // GameOption
  static const String createGameOption = "create";
  static const String createGroupedGameOptions = "create-grouped";
  static const String updateGameOption = "update";
  static String deleteGameOption(String id) => "delete/$id";

  // LearningList
  static const String createLearningList = "learningList/create";
  static const String updateLearningList = "learningList/update";
  static const String addRemoveKnowledgesToLearningList =
      "learningList/add-remove-knowledges";
  static const String getAllLearningLists = "learningList/list";
  static String getLearningListByGuid(String id) => "learningList/detailed/$id";
  static String deleteLearningList(String id) => "learningList/delete/$id";

  // PublicationRequest
  static const String requestPublishKnowledge =
      "publicationRequest/request-publish";
  static String deletePublicationRequest(String id) =>
      "publicationRequest/delete-request/$id";
  static const String getPublicationRequests =
      "publicationRequest/get-requests";
  static const String approveRejectPublicationRequest =
      "publicationRequest/approve-reject";
  static const String updateKnowledgeVisibility =
      "publicationRequest/update-visibility";
}
