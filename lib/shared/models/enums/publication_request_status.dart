enum PublicationRequestStatus {
  pending,
  approved,
  rejected,
}

extension PublicationRequestStatusExtension on PublicationRequestStatus {
  static PublicationRequestStatus fromJson(String json) {
    switch (json) {
      case 'Pending':
        return PublicationRequestStatus.pending;
      case 'Approved':
        return PublicationRequestStatus.approved;
      case 'Rejected':
        return PublicationRequestStatus.rejected;
      default:
        throw ArgumentError('Unknown status: $json');
    }
  }

  String toJson() {
    switch (this) {
      case PublicationRequestStatus.pending:
        return 'Pending';
      case PublicationRequestStatus.approved:
        return 'Approved';
      case PublicationRequestStatus.rejected:
        return 'Rejected';
    }
  }
}
