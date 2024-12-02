import 'cart_model.dart';
// Tambahkan import user model

class TransactionModel {
  String? id;
  String? status;
  double? totalPrice;
  double? shippingPrice;
  String? paymentMethod;
  String? address;
  List<CartModel>? items;
  DateTime? createdAt;

  // Tambahkan field untuk informasi user
  int? userId;
  String? userName;
  String? userEmail;

  TransactionModel({
    this.id,
    this.status,
    this.totalPrice,
    this.shippingPrice,
    this.paymentMethod,
    this.address,
    this.items,
    this.createdAt,
    this.userId,
    this.userName,
    this.userEmail,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString(),
      status: json['status'],
      totalPrice: double.parse(json['total_price'].toString()),
      shippingPrice: double.parse(json['shipping_price'].toString()),
      paymentMethod: json['payment_method'],
      address: json['address'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => CartModel.fromJson(item))
              .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,

      // Tambahkan parsing untuk informasi user
      userId:
          json['userId'] != null ? int.parse(json['userId'].toString()) : null,
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'total_price': totalPrice,
      'shipping_price': shippingPrice,
      'payment_method': paymentMethod,
      'address': address,
      'items': items?.map((item) => item.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),

      // Tambahkan informasi user ke JSON
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
    };
  }
}
