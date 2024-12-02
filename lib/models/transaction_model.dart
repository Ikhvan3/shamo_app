import 'cart_model.dart';

class TransactionModel {
  String? id;
  String? status;
  double? totalPrice;
  double? shippingPrice;
  String? paymentMethod;
  String? address;
  List<CartModel>? items;
  DateTime? createdAt;

  TransactionModel({
    this.id,
    this.status,
    this.totalPrice,
    this.shippingPrice,
    this.paymentMethod,
    this.address,
    this.items,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
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
    };
  }
}
