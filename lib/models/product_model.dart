import 'package:shamo_app/models/category_model.dart';
import 'package:shamo_app/models/gallery_model.dart';

class ProductModel {
  int? id;
  String? name;
  double? price;
  String? description;
  String? tags;
  CategoryModel? category;
  DateTime? createdAt;
  DateTime? updateAt;
  List<GalleryModel>? galleries;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.description,
    this.tags,
    this.category,
    this.createdAt,
    this.updateAt,
    this.galleries,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? ''; // Jika name null, set dengan string kosong
    price = double.tryParse(json['price'].toString()) ??
        0.0; // Jika tidak bisa parse, set ke 0.0
    description = json['description'] ?? '';
    tags = json['tags'] ?? '';

    // Pastikan category tidak null, jika tidak ada, buat category default
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : CategoryModel(id: 0, name: 'Unknown');

    // Pastikan galleries tidak null, jika null, buat list kosong
    galleries = json['galleries'] != null
        ? json['galleries']
            .map<GalleryModel>((gallery) => GalleryModel.fromJson(gallery))
            .toList()
        : [];

    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    updateAt = json['updateAt'] != null
        ? DateTime.parse(json['updateAt'])
        : DateTime.now();
  }

  // ProductModel.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   name = json['name'];
  //   price = double.parse(json['price'].toString());
  //   description = json['description'];
  //   tags = json['tags'];
  //   category = CategoryModel.fromJson(json['category']);
  //   galleries = json['galleries']
  //       .map<GalleryModel>((gallery) => GalleryModel.fromJson(gallery))
  //       .toList();
  //   createdAt = DateTime.parse(json['createdAt']);
  //   updateAt = DateTime.parse(json['updateAt']);
  // }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'tags': tags,
      'category': category?.toJson(),
      'galleries': galleries?.map((gallery) => gallery.toJson()).toList(),
      'createdAt': createdAt.toString(),
      'updateAt': updateAt.toString(),
    };
  }
}
