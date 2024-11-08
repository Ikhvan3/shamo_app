import 'package:shamo_app/helpers/image_url_helper.dart';

class GalleryModel {
  int? id;
  String? url;
  String? fullUrl;

  GalleryModel({
    required this.id,
    required this.url,
    required this.fullUrl,
  });

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    fullUrl = json['full_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'fullUrl': fullUrl,
    };
  }
}
