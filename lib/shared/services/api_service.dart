import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udetxen/shared/constants/error_message.dart';
import 'package:udetxen/shared/constants/http_route.dart';
import 'package:udetxen/shared/constants/urls.dart';

import '../config/service_locator.dart';
import '../types/index.dart';

abstract class ApiService {
  ApiResponse<T> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>)? fromJson,
  ) async {
    return _performApiCall<T>(
      (headers) =>
          http.get(Uri.parse('${Urls.apiUrl}/$endpoint'), headers: headers),
      fromJson == null ? null : (data) => fromJson(data),
    );
  }

  ApiResponse<List<T>> getList<T>(
    String endpoint,
    T Function(dynamic) fromJson,
  ) async {
    return _performApiCall<List<T>>(
      (headers) =>
          http.get(Uri.parse('${Urls.apiUrl}/$endpoint'), headers: headers),
      (data) {
        if (data is List) return data.map((item) => fromJson(item)).toList();

        throw FormatException('Expected list but got ${data.runtimeType}');
      },
    );
  }

  ApiResponse<T> post<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
  ) async {
    return _performApiCall<T>(
      (headers) => http.post(
        Uri.parse('${Urls.apiUrl}/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ),
      (data) {
        if (data is Map<String, dynamic>) return fromJson(data);

        throw FormatException('Expected map but got ${data.runtimeType}');
      },
    );
  }

  ApiResponse<T> postMultipart<T>(
      String endpoint,
      T Function(Map<String, dynamic>) fromJson,
      Map<String, dynamic> fields,
      List<(XFile, String)> files) async {
    return _performApiCall<T>(
      (headers) async {
        final uri = Uri.parse('${Urls.apiUrl}/$endpoint');
        final request = http.MultipartRequest('POST', uri);

        void addFields(String key, dynamic value) {
          if (value is String) {
            request.fields[key] = value;
          } else if (value is List<String>) {
            for (var i = 0; i < value.length; i++) {
              request.fields['$key[$i]'] = value[i];
            }
          } else if (value is List<Map<String, dynamic>>) {
            for (var i = 0; i < value.length; i++) {
              value[i].forEach((subKey, subValue) {
                if (subValue != null) addFields('$key[$i][$subKey]', subValue);
              });
            }
          } else if (value is Map<String, dynamic>) {
            value.forEach((subKey, subValue) {
              addFields('$key[$subKey]', subValue);
            });
          } else if (value is int || value is double || value is bool) {
            request.fields[key] = value.toString();
          } else {
            throw UnsupportedError(
                'Unsupported field type: ${value.runtimeType}');
          }
        }

        fields.forEach((key, value) {
          addFields(key, value);
        });

        for (var file in files) {
          final mimeType =
              lookupMimeType(file.$1.path) ?? 'application/octet-stream';
          final mediaType = MediaType.parse(mimeType);
          request.files.add(
            http.MultipartFile.fromBytes(
              file.$2,
              await file.$1.readAsBytes(),
              filename: file.$1.name,
              contentType: mediaType,
            ),
          );
        }

        request.headers.addAll(headers);
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        return response;
      },
      (data) {
        if (data is Map<String, dynamic>) return fromJson(data);

        throw FormatException('Expected map but got ${data.runtimeType}');
      },
    );
  }

  ApiResponse<Page<T>> postPage<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
  ) async {
    return _performApiCall<Page<T>>(
      (headers) => http.post(
        Uri.parse('${Urls.apiUrl}/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ),
      (data) {
        if (data is Map<String, dynamic>) return Page.fromJson(data, fromJson);

        throw FormatException('Expected map but got ${data.runtimeType}');
      },
    );
  }

  ApiResponse<List<T>> postList<T>(
    String endpoint,
    T Function(dynamic) fromJson,
    Map<String, dynamic>? data,
  ) {
    return _performApiCall<List<T>>(
      (headers) => http.post(
        Uri.parse('${Urls.apiUrl}/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ),
      (data) {
        if (data is List) return data.map((item) => fromJson(item)).toList();

        throw FormatException('Expected List but got ${data.runtimeType}');
      },
    );
  }

  ApiResponse<T> delete<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
  ) async {
    return _performApiCall<T>(
      (headers) => http.delete(
        Uri.parse('${Urls.apiUrl}/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      ),
      (data) {
        if (data is Map<String, dynamic>) return fromJson(data);

        throw FormatException('Expected list but got ${data.runtimeType}');
      },
    );
  }

  ApiResponse<T> _performApiCall<T>(
      Future<http.Response> Function(Map<String, String> headers) apiCall,
      T Function(dynamic data)? fromJson,
      {String? mediaType}) async {
    try {
      final headers = await _getHeaders(mediaType);
      var response = await apiCall(headers);

      if (response.statusCode == 401) {
        final newAccessToken = await _refreshToken();
        if (newAccessToken == null) {
          return Response(
              failure: Failure(message: 'Login timeout, please login again'));
        }

        final retryHeaders = await _getHeaders(mediaType);
        response = await apiCall(retryHeaders);
        return _handleResponse(response, fromJson);
      }

      return _handleResponse(response, fromJson);
    } catch (e) {
      return Response(failure: Failure(message: e.toString()));
    }
  }

  Response<T> _handleResponse<T>(
      http.Response response, Function(dynamic data)? fromJson) {
    if (response.statusCode == 200) {
      if (fromJson == null) {
        return Response(data: _castResponseBody<T>(response.body));
      }

      final responseData = jsonDecode(response.body);
      if (responseData is List || responseData is Map) {
        return Response(data: fromJson(responseData));
      } else {
        return Response(failure: Failure(message: "Unexpected data format"));
      }
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(response.body);
      if (responseData is Map && responseData['errors'] != null) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        if (errors['request'] != null) {
          return Response(failure: Failure(message: 'Some fields are missing'));
        }

        Map<String, List<String>> validationErrors = {};
        errors.forEach((key, value) {
          if (value is List) {
            validationErrors[key] = value.map((e) => e.toString()).toList();
          } else {
            validationErrors[key] = [value.toString()];
          }
        });

        return Response(failure: Failure(fieldErrors: validationErrors));
      } else if (responseData is List) {
        return Response(
            failure: Failure(
                errors: (responseData)
                    .map((e) => ErrorMessageExtension.fromString(e as String))
                    .toList()));
      }

      return Response(failure: Failure(message: 'Unknown validation error'));
    } else if (response.statusCode == 500) {
      return Response(failure: Failure(message: 'Internal server error'));
    }

    return Response(failure: Failure(message: 'Unexpected error'));
  }

  T _castResponseBody<T>(String body) {
    if (T == int) {
      return int.tryParse(body) as T;
    } else if (T == double) {
      return double.tryParse(body) as T;
    } else if (T == String) {
      return body as T;
    } else if (T == bool) {
      return (body.toLowerCase() == 'true') as T;
    } else {
      throw UnsupportedError('Unsupported type: $T');
    }
  }

  Future<Map<String, String>> _getHeaders(String? mediaType) async {
    final prefs = getIt<SharedPreferences>();
    final token = prefs.getString('accessToken');

    final headers = <String, String>{};

    headers['Content-Type'] = mediaType ?? "application/json";

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<String?> _refreshToken() async {
    final prefs = getIt<SharedPreferences>();
    final refreshToken = prefs.getString('refreshToken');
    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('${Urls.apiUrl}/${HttpRoute.refreshAccessToken}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newAccessToken = responseData['accessToken'];
        final newRefreshToken = responseData['refreshToken'];
        await prefs.setString('accessToken', newAccessToken);
        await prefs.setString('refreshToken', newRefreshToken);
        return newAccessToken;
      } else if (response.statusCode == 400) {
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');
      }
    }
    return null;
  }
}

class JWTPairResponse {
  final String accessToken;
  final String refreshToken;

  JWTPairResponse({required this.accessToken, required this.refreshToken});

  factory JWTPairResponse.fromJson(Map<String, dynamic> json) {
    return JWTPairResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
