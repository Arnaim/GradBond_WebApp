class StorageService {
  static Future<void> saveToken(String token) async {
    throw UnsupportedError('StorageService not supported on this platform');
  }

  static Future<String?> getToken() async {
    throw UnsupportedError('StorageService not supported on this platform');
  }

  static Future<void> clearToken() async {
    throw UnsupportedError('StorageService not supported on this platform');
  }
}
