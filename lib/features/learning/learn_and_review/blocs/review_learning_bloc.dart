import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udetxen/features/learning/learn_and_review/models/review_learning.dart';
import 'package:udetxen/features/learning/learn_and_review/services/learn_and_review_service.dart';
import 'package:udetxen/shared/models/index.dart';

// Events
abstract class ReviewLearningEvent {
  const ReviewLearningEvent();
}

class ReviewLearningRequested extends ReviewLearningEvent {
  final ReviewLearningRequest request;

  const ReviewLearningRequested(this.request);
}

// States
abstract class ReviewLearningState {
  const ReviewLearningState();
}

class ReviewLearningInitial extends ReviewLearningState {}

class ReviewLearningLoading extends ReviewLearningState {}

class ReviewLearningSuccess extends ReviewLearningState {
  final List<Learning> learnings;

  const ReviewLearningSuccess(this.learnings);
}

class ReviewLearningFailure extends ReviewLearningState {
  final List<String> messages;

  const ReviewLearningFailure(this.messages);
}

// BLoC
class ReviewLearningBloc
    extends Bloc<ReviewLearningEvent, ReviewLearningState> {
  final LearnAndReviewService _learnAndReviewService;

  ReviewLearningBloc(this._learnAndReviewService)
      : super(ReviewLearningInitial()) {
    on<ReviewLearningRequested>(_onReviewLearningRequested);
  }

  Future<void> _onReviewLearningRequested(
    ReviewLearningRequested event,
    Emitter<ReviewLearningState> emit,
  ) async {
    emit(ReviewLearningLoading());
    final response = await _learnAndReviewService.reviewLearning(event.request);
    response.on(
      onSuccess: (learnings) => emit(ReviewLearningSuccess(learnings)),
      onFailure: (errors, _) => emit(ReviewLearningFailure(errors)),
    );
  }
}
