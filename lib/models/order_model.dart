import 'package:shamo_app/models/cart_model.dart';

class OrderModel {
  final String orderId;
  final List<CartModel> items;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final DateTime orderDate;
  final String deliveryAddress;

  OrderModel({
    required this.orderId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.orderDate,
    required this.deliveryAddress,
  });

  // Method to convert from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      items: List<CartModel>.from(
        json['items'].map(
          (item) => CartModel.fromJson(
            {'id': item['cartId']}, // Data tambahan
            item, // Data utama
          ),
        ),
      ),
      totalPrice: json['totalPrice'],
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      orderDate: DateTime.parse(json['orderDate']),
      deliveryAddress: json['deliveryAddress'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'items': items
          .map((item) => item.toJson())
          .toList(), // Pastikan CartModel memiliki toJson
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate.toIso8601String(),
      'deliveryAddress': deliveryAddress,
    };
  }
}
