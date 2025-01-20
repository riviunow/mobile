class GetForMigrationRequest {
  final String? parentId;

  GetForMigrationRequest({this.parentId});

  Map<String, dynamic> toJson() {
    return {
      'parentId': parentId,
    };
  }
}
