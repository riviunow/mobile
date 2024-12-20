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
    switch (this) {
      case ErrorMessage.unknownError:
        return "An unknown error occurred.";
      case ErrorMessage.noChangeDetected:
        return "No changes were detected.";
      case ErrorMessage.invalidData:
        return "The data provided is invalid.";
      case ErrorMessage.noData:
        return "No data available.";
      case ErrorMessage.emailNotSent:
        return "Failed to send email.";
      case ErrorMessage.storeFileError:
        return "Failed to store the file.";
      case ErrorMessage.deleteFileError:
        return "Failed to delete the file.";
      case ErrorMessage.wrongPassword:
        return "The password is incorrect.";
      case ErrorMessage.emailNotConfirmed:
        return "Email is not confirmed.";
      case ErrorMessage.accountIsLocked:
        return "The account is locked.";
      case ErrorMessage.invalidConfirmationCode:
        return "The confirmation code is invalid.";
      case ErrorMessage.confirmationCodeExpired:
        return "The confirmation code has expired.";
      case ErrorMessage.confirmationCodeNotExpired:
        return "The confirmation code has not expired. Please wait to request a new one.";
      case ErrorMessage.emailAlreadyConfirmed:
        return "Email is already confirmed.";
      case ErrorMessage.userAlreadyLoggedOut:
        return "User is already logged out.";
      case ErrorMessage.accessTokenIsInvalid:
        return "The access token is invalid.";
      case ErrorMessage.accessTokenIsExpired:
        return "The access token has expired.";
      case ErrorMessage.refreshTokenNotFound:
        return "The refresh token was not found.";
      case ErrorMessage.refreshTokenIsInvalid:
        return "The refresh token is invalid.";
      case ErrorMessage.refreshTokenIsExpired:
        return "The refresh token has expired.";
      case ErrorMessage.userNotFound:
        return "User not found.";
      case ErrorMessage.userNotFoundWithEmail:
        return "User not found with the provided email.";
      case ErrorMessage.userAlreadyExists:
        return "User already exists.";
      case ErrorMessage.userAlreadyExistsWithSameEmail:
        return "User already exists with the same email.";
      case ErrorMessage.userIsNotActive:
        return "User is not active.";
      case ErrorMessage.userNotAuthorized:
        return "User is not authorized.";
      case ErrorMessage.userIsNotAdmin:
        return "User is not an admin.";
      case ErrorMessage.noTracksFound:
        return "No tracks found.";
      case ErrorMessage.noTrackFoundWithSearch:
        return "No track found with the provided search criteria.";
      case ErrorMessage.noTrackFoundWithGuid:
        return "No track found with the provided ID.";
      case ErrorMessage.noSubjectsFound:
        return "No subjects found.";
      case ErrorMessage.noSubjectFoundWithGuid:
        return "No subject found with the provided ID.";
      case ErrorMessage.noKnowledgesFound:
        return "No knowledges found.";
      case ErrorMessage.noKnowledgeFoundWithGuid:
        return "No knowledge found with the provided ID.";
      case ErrorMessage.someKnowledgesNotFound:
        return "Some knowledges were not found.";
      case ErrorMessage.knowledgeIsPrivate:
        return "The knowledge is private.";
      case ErrorMessage.noKnowledgeTypesFound:
        return "No knowledge types found.";
      case ErrorMessage.noKnowledgeTypeFoundWithGuid:
        return "No knowledge type found with the provided ID.";
      case ErrorMessage.someKnowledgeTypesNotFound:
        return "Some knowledge types were not found.";
      case ErrorMessage.knowledgeTypeAlreadyExists:
        return "The knowledge type already exists.";
      case ErrorMessage.cannotBeParentOfItself:
        return "A knowledge type cannot be its own parent.";
      case ErrorMessage.noKnowledgeTopicFoundWithGuid:
        return "No knowledge topic found with the provided ID.";
      case ErrorMessage.someKnowledgeTopicsNotFound:
        return "Some knowledge topics were not found.";
      case ErrorMessage.noKnowledgeTopicsFound:
        return "No knowledge topics found.";
      case ErrorMessage.knowledgeTopicAlreadyExists:
        return "The knowledge topic already exists.";
      case ErrorMessage.noInterpretationForKnowledge:
        return "No interpretation found for the knowledge.";
      case ErrorMessage.knowledgeAlreadyLearned:
        return "The knowledge has already been learned.";
      case ErrorMessage.someKnowledgesAlreadyLearned:
        return "Some knowledges have already been learned.";
      case ErrorMessage.someKnowledgesHaveNotBeenLearned:
        return "Some knowledges have not been learned.";
      case ErrorMessage.someKnowledgesAreNotReadyToReview:
        return "Some knowledges are not ready to review.";
      case ErrorMessage.knowledgeNotReadyToReview:
        return "The knowledge is not ready to review.";
      case ErrorMessage.learningNotFound:
        return "Learning not found.";
      case ErrorMessage.noLearningsFound:
        return "No learnings found.";
      case ErrorMessage.requireLearningBeforeReview:
        return "Learning is required before review.";
      case ErrorMessage.requireTwoGamesToLearn:
        return "Two games are required to learn.";
      case ErrorMessage.requireAGameToReview:
        return "A game is required to review.";
      case ErrorMessage.gameKnowledgeSubscriptionNotFound:
        return "Game knowledge subscription not found.";
      case ErrorMessage.gameKnowledgeSubscriptionAlreadyExists:
        return "Game knowledge subscription already exists.";
      case ErrorMessage.noGameFoundWithGuid:
        return "No game found with the provided ID.";
      case ErrorMessage.noGamesFound:
        return "No games found.";
      case ErrorMessage.gameOptionGroupNotFound:
        return "Game option group not found.";
      case ErrorMessage.gameOptionNotFoundWithGuid:
        return "Game option not found with the provided ID.";
      case ErrorMessage.requireExactOneQuestion:
        return "Exactly one question is required.";
      case ErrorMessage.requireAtLeastTwoAnswers:
        return "At least two answers are required.";
      case ErrorMessage.requireExactOneCorrectAnswer:
        return "Exactly one correct answer is required.";
      case ErrorMessage.cannotDeleteCorrectAnswer:
        return "Cannot delete the correct answer.";
      case ErrorMessage.learningListTitleExisted:
        return "The learning list title already exists.";
      case ErrorMessage.noLearningListFoundWithGuid:
        return "No learning list found with the provided ID.";
      case ErrorMessage.noPublicationRequestFoundWithGuid:
        return "No publication request found with the provided ID.";
      case ErrorMessage.knowledgeAlreadyRequestedForPublication:
        return "The knowledge has already been requested for publication.";
      case ErrorMessage.publicationRequestAlreadyApproved:
        return "The publication request has already been approved.";
      case ErrorMessage.publicationRequestAlreadyApprovedOrRejected:
        return "The publication request has already been approved or rejected.";
      case ErrorMessage.noPublicationRequestsFound:
        return "No publication requests found.";
      default:
        return "An unknown error occurred.";
    }
  }
}
