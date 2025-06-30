class StorageService {
  // Stub method to save token — throws error because not supported on this platform
  static Future<void> saveToken(String token) async {
    throw UnsupportedError('StorageService not supported on this platform');
  }

  // Stub method to get token — throws error because not supported on this platform
  static Future<String?> getToken() async {
    throw UnsupportedError('StorageService not supported on this platform');
  }

  // Stub method to clear token — throws error because not supported on this platform
  static Future<void> clearToken() async {
    throw UnsupportedError('StorageService not supported on this platform');
  }
}
