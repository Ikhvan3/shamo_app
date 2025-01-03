import 'package:shamo_app/models/product_model.dart';

class CartModel {
  String? id;
  ProductModel? product;
  int? quantity;

  CartModel({
    this.id,
    this.product,
    this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json, [item]) {
    return CartModel(
      id: json['cartId'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': id,
      'product': product?.toJson(),
      'quantity': quantity,
    };
  }

  double getTotalPrice() {
    return (product?.price ?? 0) * (quantity ?? 0);
  }
}
