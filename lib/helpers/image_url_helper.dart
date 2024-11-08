class AppConfig {
  static const String baseUrl = 'http://192.168.1.10:8000';
  static const String apiUrl = '$baseUrl/api';

  static String getFullImageUrl(String path) {
    if (path.startsWith('http')) {
      return path;
    }
    // Pastikan path dimulai dengan /storage/
    if (!path.startsWith('/storage/')) {
      path = '/storage/' + path.replaceAll('/storage/', '');
    }
    return '$baseUrl$path';
  }
}
