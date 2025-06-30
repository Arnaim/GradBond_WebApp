import 'dart:html' as html;

class StorageService {
  // Save token to browser localStorage
  static Future<void> saveToken(String token) async {
    html.window.localStorage['auth_token'] = token;
  }

  // Get token from browser localStorage
  static Future<String?> getToken() async {
    return html.window.localStorage['auth_token'];
  }

  // Remove token from browser localStorage
  static Future<void> clearToken() async {
    html.window.localStorage.remove('auth_token');
  }
}
