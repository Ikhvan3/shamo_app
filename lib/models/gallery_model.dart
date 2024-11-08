class GalleryModel {
  int? id;
  String? url;

  GalleryModel({
    this.id,
    this.url,
  });

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    // Pastikan URL menggunakan format yang benar dengan /storage/
    String baseUrl = 'http://192.168.1.10:8000';
    String imagePath = json['url'] ?? '';

    // Jika URL sudah lengkap, gunakan URL tersebut
    if (imagePath.startsWith('http')) {
      url = imagePath;
    } else {
      // Jika path tidak dimulai dengan /storage/, tambahkan
      if (!imagePath.startsWith('/storage/')) {
        imagePath = '/storage/' + imagePath.replaceAll('/storage/', '');
      }

      // Gabungkan baseUrl dengan imagePath
      url = baseUrl + imagePath;
    }

    // Print URL untuk debugging
    print('Constructed image URL: $url');
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
