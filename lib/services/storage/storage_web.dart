import 'dart:html' as html;

class StorageService {
  static Future<void> saveToken(String token) async {
    html.window.localStorage['auth_token'] = token;
  }

  static Future<String?> getToken() async {
    return html.window.localStorage['auth_token'];
  }

  static Future<void> clearToken() async {
    html.window.localStorage.remove('auth_token');
  }
}
