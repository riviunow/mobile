import 'package:shared_preferences/shared_preferences.dart';

class JwtService {
  final SharedPreferences _sharedPreferences;

  JwtService(this._sharedPreferences);

  String? get accessToken => _sharedPreferences.getString('accessToken');
  String? get refreshToken => _sharedPreferences.getString('refreshToken');

  Future<void> setAccessToken(String accessToken) async {
    await _sharedPreferences.setString('accessToken', accessToken);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await _sharedPreferences.setString('refreshToken', refreshToken);
  }

  Future<void> removeAccessToken() async {
    await _sharedPreferences.remove('accessToken');
  }

  Future<void> removeRefreshToken() async {
    await _sharedPreferences.remove('refreshToken');
  }
}
