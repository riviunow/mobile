part of 'index.dart';

class Track extends SingleIdEntity {
  final String name;
  final String description;
  final List<TrackSubject> trackSubjects;
  final int subjectCount;

  Track({
    required super.id,
    required super.createdAt,
    required this.name,
    required this.description,
    this.trackSubjects = const [],
    required this.subjectCount,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      createdAt: parseUtcDateTime(json['createdAt'] as String),
      name: json['name'],
      description: json['description'],
      trackSubjects: (json['trackSubjects'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => TrackSubject.fromJson(e))
              .toList() ??
          [],
      subjectCount: json['subjectCount'],
    );
  }

  Track copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? description,
    List<TrackSubject>? trackSubjects,
    int? subjectCount,
  }) {
    return Track(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      description: description ?? this.description,
      trackSubjects: trackSubjects ?? this.trackSubjects,
      subjectCount: subjectCount ?? this.subjectCount,
    );
  }
}
