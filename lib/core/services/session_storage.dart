import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const _tokenKey = 'jert_session_token';
  static const _userIdKey = 'jert_user_id';

  Future<void> saveSession({
    required String sessionToken,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, sessionToken);
    await prefs.setString(_userIdKey, userId);
  }

  Future<StoredSession?> readSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userId = prefs.getString(_userIdKey);

    if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
      return null;
    }

    return StoredSession(
      sessionToken: token,
      userId: userId,
    );
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }
}

class StoredSession {
  final String sessionToken;
  final String userId;

  const StoredSession({
    required this.sessionToken,
    required this.userId,
  });
}
