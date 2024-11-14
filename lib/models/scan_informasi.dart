import 'dart:convert';

class ProductInfo {
  final String id;
  final String name;
  final String category;
  final double price;
  final Map<String, String> nutrients;
  final List<Map<String, String>> benefits;

  ProductInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.nutrients,
    required this.benefits,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    try {
      return ProductInfo(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
        nutrients: (json['nutrients'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ) ??
            {},
        benefits: (json['benefits'] as List<dynamic>?)
                ?.map((e) => {
                      'title': e['title']?.toString() ?? '',
                      'description': e['description']?.toString() ?? ''
                    })
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error in ProductInfo.fromJson: $e');
      rethrow;
    }
  }

  static ProductInfo? fromQRString(String qrString) {
    try {
      // Tambahkan log untuk debugging
      print('QR Data: $qrString');

      // Coba parse JSON
      final Map<String, dynamic> json = jsonDecode(qrString);
      print('Parsed JSON: $json');

      return ProductInfo.fromJson(json);
    } catch (e) {
      print('Error parsing QR code: $e');
      return null;
    }
  }
}
