class AppConfig {
  static const String baseUrl = 'http://192.168.1.38:8000';
  static const String apiUrl = '$baseUrl/api';

  static String getFullImageUrl(String path) {
    if (path.startsWith('http')) {
      return path;
    }

    // Tambahkan pengecekan null dan string kosong
    if (path.isEmpty) {
      return '$baseUrl/storage/default-image.png'; // Gambar default
    }
    // Bersihkan path dari double slashes
    path = path.replaceAll('//', '/');
    if (!path.startsWith('/storage/')) {
      path = '/storage/' + path.replaceAll('/storage/', '');
    }
    return '$baseUrl$path';
  }
}
