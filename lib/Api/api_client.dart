import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'http://116.203.172.111:7014';

  late final Dio _dio;
  bool _isRefreshing = false;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          final isAuthEndpoint = options.path.contains('/api/auth/login') ||
              options.path.contains('/api/auth/register');

          if (!isAuthEndpoint) {
            final token = await TokenManager.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {

          final isAuthEndpoint = error.requestOptions.path.contains('/api/auth/login') ||
              error.requestOptions.path.contains('/api/auth/register') ||
              error.requestOptions.path.contains('/api/auth/refresh');


          if (isAuthEndpoint) {
            return handler.next(error);
          }


          if (error.response?.statusCode == 401 && !_isRefreshing) {
            try {
              _isRefreshing = true;
              print(' Token expired. Refreshing...');

              final refreshToken = await TokenManager.getRefreshToken();
              if (refreshToken == null) {
                _isRefreshing = false;
                return handler.next(error);
              }

              final response = await _dio.post(
                '/api/auth/refresh',
                data: {'refreshToken': refreshToken},
              );

              if (response.data['token'] != null) {
                await TokenManager.saveTokens(
                  response.data['token'],
                  response.data['refreshToken'] ?? refreshToken,
                );
                print(' Token refreshed successfully');


                final request = error.requestOptions;
                request.headers['Authorization'] = 'Bearer ${response.data['token']}';
                final retryResponse = await _dio.fetch(request);
                _isRefreshing = false;
                return handler.resolve(retryResponse);
              }
            } catch (e) {
              print(' Refresh failed: $e');
              await TokenManager.clearTokens();
              _isRefreshing = false;
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // ── LOGIN API ──────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      print(' Login Response: ${response.data}');

      final data = response.data;
      if (data['token'] != null && data['refreshToken'] != null) {
        await TokenManager.saveTokens(
          data['token'],
          data['refreshToken'],
        );
        if (data['user'] != null) {
          await TokenManager.saveUser(data['user']);
        }
      }

      return data;
    } on DioException catch (e) {
      print(' Login Error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ── REGISTER API ────────────────────────────────────────────
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: userData,
      );

      print('Register Response: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('Register Error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ── LOGOUT API ──────────────────────────────────────────────
  Future<void> logout() async {
    try {
      final token = await TokenManager.getAccessToken();
      if (token != null) {
        await _dio.post(
          '/api/auth/logout',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        print('Logout successful on server');
      }
      await TokenManager.clearTokens();
      print('🗑️ Local tokens cleared');
    } on DioException catch (e) {
      print('Logout error: $e');
      await TokenManager.clearTokens();
      rethrow;
    }
  }

// ── GET CURRENT USER ────────────────────────────────────────
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await TokenManager.getAccessToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await _dio.get(
        '/api/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('  User Data from /me: ${response.data}');

      // API response mein 'user' key ke ander data hai
      if (response.data != null && response.data['user'] != null) {
        print(' Extracted user data: ${response.data['user']}');
        return response.data['user'];
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── GET GRADES ──────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getGrades() async {
    try {
      final response = await _dio.get('/api/grades');
      final data = response.data as List;
      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      print('Get Grades Error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ── GET MEDIUMS ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getMediums() async {
    try {
      final response = await _dio.get('/api/mediums');
      final data = response.data as List;
      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      print('Get Mediums Error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ── ERROR HANDLER ──────────────────────────────────────────
  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'];
      }
      if (e.response?.statusCode == 401) {
        return 'Invalid username or password. Please try again.';
      }
      if (e.response?.statusCode == 400) {
        return ' Please check your input.';
      }
      return 'Server error: ${e.response?.statusCode}';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Server not responding. Please try again.';
    } else {
      return 'Network error. Please check your connection.';
    }
  }
}

// ── TOKEN MANAGER ──────────────────────────────────────────────
class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _onboardingKey = 'onboarding_seen';

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    print('Tokens saved successfully');
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.toString());
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
    print(' Tokens cleared');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey) != null;
  }
}