import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shamo_app/models/cart_model.dart';
import 'package:shamo_app/models/user_model.dart';

class CartService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<CartModel>> getCartByUserId({required String userId}) {
    try {
      return firestore
          .collection('carts')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        return list.docs.map<CartModel>((DocumentSnapshot cart) {
          return CartModel.fromJson(cart.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get cart data: $e');
    }
  }

  Future<void> addToCart({
    required UserModel user,
    required CartModel cart,
  }) async {
    try {
      var docRef = firestore.collection('carts').doc(); // Generate ID unik
      await docRef.set({
        'cartId': docRef.id,
        'userId': user.id.toString(),
        'product': cart.product!.toJson(),
        'quantity': cart.quantity,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  Future<void> updateCartItem({
    required String cartId,
    required int quantity,
  }) async {
    try {
      await firestore.collection('carts').doc(cartId).update({
        'quantity': quantity,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  Future<void> removeFromCart({required String cartId}) async {
    try {
      await firestore.collection('carts').doc(cartId).delete();
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }
}
