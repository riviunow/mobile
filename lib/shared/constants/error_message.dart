import 'package:easy_localization/easy_localization.dart';

enum ErrorMessage {
  unknownError,
  noChangeDetected,
  invalidData,
  noData,
  emailNotSent,
  storeFileError,
  deleteFileError,
  wrongPassword,
  emailNotConfirmed,
  accountIsLocked,
  invalidConfirmationCode,
  confirmationCodeExpired,
  confirmationCodeNotExpired,
  emailAlreadyConfirmed,
  userAlreadyLoggedOut,
  accessTokenIsInvalid,
  accessTokenIsExpired,
  refreshTokenNotFound,
  refreshTokenIsInvalid,
  refreshTokenIsExpired,
  userNotFound,
  userNotFoundWithEmail,
  userAlreadyExists,
  userAlreadyExistsWithSameEmail,
  userIsNotActive,
  userNotAuthorized,
  userIsNotAdmin,
  noTracksFound,
  noTrackFoundWithSearch,
  noTrackFoundWithGuid,
  noSubjectsFound,
  noSubjectFoundWithGuid,
  noKnowledgesFound,
  noKnowledgeFoundWithGuid,
  someKnowledgesNotFound,
  knowledgeIsPrivate,
  noKnowledgeTypesFound,
  noKnowledgeTypeFoundWithGuid,
  someKnowledgeTypesNotFound,
  knowledgeTypeAlreadyExists,
  cannotBeParentOfItself,
  noKnowledgeTopicFoundWithGuid,
  someKnowledgeTopicsNotFound,
  noKnowledgeTopicsFound,
  knowledgeTopicAlreadyExists,
  noInterpretationForKnowledge,
  knowledgeAlreadyLearned,
  someKnowledgesAlreadyLearned,
  someKnowledgesHaveNotBeenLearned,
  someKnowledgesAreNotReadyToReview,
  knowledgeNotReadyToReview,
  learningNotFound,
  noLearningsFound,
  requireLearningBeforeReview,
  requireTwoGamesToLearn,
  requireAGameToReview,
  gameKnowledgeSubscriptionNotFound,
  gameKnowledgeSubscriptionAlreadyExists,
  noGameFoundWithGuid,
  noGamesFound,
  gameOptionGroupNotFound,
  gameOptionNotFoundWithGuid,
  requireExactOneQuestion,
  requireAtLeastTwoAnswers,
  requireExactOneCorrectAnswer,
  cannotDeleteCorrectAnswer,
  learningListTitleExisted,
  noLearningListFoundWithGuid,
  noPublicationRequestFoundWithGuid,
  knowledgeAlreadyRequestedForPublication,
  publicationRequestAlreadyApproved,
  publicationRequestAlreadyApprovedOrRejected,
  noPublicationRequestsFound,
}

extension ErrorMessageExtension on ErrorMessage {
  static ErrorMessage fromString(String error) {
    return ErrorMessage.values.firstWhere(
      (e) => e.name.toLowerCase() == error.toLowerCase(),
      orElse: () => ErrorMessage.unknownError,
    );
  }

  String get userFriendlyMessage {
    return 'errorMessage.$name'.tr();
  }
}
