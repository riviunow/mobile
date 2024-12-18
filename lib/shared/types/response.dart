part of 'index.dart';

typedef ApiResponse<T> = Future<Response<T>>;

class Response<T> {
  final T? data;
  final Failure? failure;

  bool get isSuccess => data != null;

  Response({this.data, this.failure});

  Future<void> on({
    required Function(
            List<String> messages, Map<String, List<String>> fieldErrors)
        onFailure,
    required Function(T data) onSuccess,
  }) async {
    if (isSuccess) {
      await onSuccess(data as T);
    } else {
      await onFailure([
        if (failure!.message != null) failure!.message!,
        ...failure!.errors.map((e) => e.userFriendlyMessage)
      ], failure!.fieldErrors);
    }
  }
}

class Failure {
  final String? message;
  final List<ErrorMessage> errors;
  final Map<String, List<String>> fieldErrors;

  Failure({this.errors = const [], this.fieldErrors = const {}, this.message});
}
