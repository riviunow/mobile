part of 'index.dart';

class TrackSubject {
  final String trackId;
  final Track? track;
  final String subjectId;
  final Subject? subject;

  TrackSubject({
    required this.trackId,
    this.track,
    required this.subjectId,
    this.subject,
  });

  factory TrackSubject.fromJson(Map<String, dynamic> json) {
    return TrackSubject(
      trackId: json['trackId'],
      track: json['track'] != null ? Track.fromJson(json['track']) : null,
      subjectId: json['subjectId'],
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
    );
  }

  TrackSubject copyWith({
    String? trackId,
    Track? track,
    String? subjectId,
    Subject? subject,
  }) {
    return TrackSubject(
      trackId: trackId ?? this.trackId,
      track: track ?? this.track,
      subjectId: subjectId ?? this.subjectId,
      subject: subject ?? this.subject,
    );
  }
}
