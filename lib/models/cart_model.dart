import 'package:shamo_app/models/product_model.dart';

class CartModel {
  int? id;
  ProductModel? product;
  int? quantity;

  CartModel({
    this.id,
    this.product,
    this.quantity,
  });

  factory CartModel.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> data) {
    return CartModel(
      id: json['cartId'],
      product: data['product'] != null
          ? ProductModel.fromJson(data['product'])
          : null,
      quantity: data['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': id,
      'product': product!.toJson(),
      'quantity': quantity,
    };
  }

  double getTotalPrice() {
    return product!.price! * quantity!;
  }
}
