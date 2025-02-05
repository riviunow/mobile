import 'package:flutter_dotenv/flutter_dotenv.dart';

class Urls {
  static final baseUrl = dotenv.env['BASE_URL']!;
  static final apiUrl = '$baseUrl/api';
  static final mediaUrl = '$baseUrl/Upload/Files';
}
