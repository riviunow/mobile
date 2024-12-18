part of 'index.dart';

class SingleIdPivotEntity {
  final String id;
  final String? modifiedBy;
  final DateTime? modifiedAt;
  final DateTime createdAt;

  SingleIdPivotEntity({
    required this.id,
    this.modifiedBy,
    this.modifiedAt,
    required this.createdAt,
  });
}
