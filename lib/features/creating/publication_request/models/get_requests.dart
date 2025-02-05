import 'package:rvnow/shared/models/enums/publication_request_status.dart';

class GetPublicationRequests {
  final String? searchTerm;
  final int page;
  final int pageSize;
  final PublicationRequestStatus? status;

  GetPublicationRequests({
    this.searchTerm,
    this.page = 1,
    this.pageSize = 10,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchTerm': searchTerm,
      'page': page,
      'pageSize': pageSize,
      'status': status?.toJson(),
    };
  }

  GetPublicationRequests copyWith({
    String? searchTerm,
    int? page,
    int? pageSize,
    PublicationRequestStatus? status,
  }) {
    return GetPublicationRequests(
      searchTerm: searchTerm ?? this.searchTerm,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      status: status ?? this.status,
    );
  }
}
