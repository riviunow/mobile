part of 'index.dart';

class Page<T> {
  final List<T> data;
  final int page;
  final int pageSize;
  final int totalElements;

  Page({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.totalElements,
  });

  factory Page.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return Page<T>(
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
      page: json['paging']['page'],
      pageSize: json['paging']['pageSize'],
      totalElements: json['paging']['totalElements'],
    );
  }

  bool get hasNext => page * pageSize < totalElements;
}
