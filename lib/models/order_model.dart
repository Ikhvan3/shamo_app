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

  // You can add a method to convert from JSON if you get the data from an API
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      items: List<CartModel>.from(
          json['items'].map((item) => CartModel.fromJson(item))),
      totalPrice: json['totalPrice'],
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      orderDate: DateTime.parse(json['orderDate']),
      deliveryAddress: json['deliveryAddress'],
    );
  }
}
