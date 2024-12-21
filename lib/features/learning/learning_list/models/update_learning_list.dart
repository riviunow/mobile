class UpdateLearningListRequest {
  final String id;
  final String title;

  UpdateLearningListRequest({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
