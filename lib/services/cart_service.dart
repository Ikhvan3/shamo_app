import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shamo_app/models/cart_model.dart';
import 'package:shamo_app/models/user_model.dart';

class CartService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<CartModel>> getCartByUserId({String? userId}) {
    try {
      return firestore
          .collection('carts')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        var result = list.docs.map<CartModel>((DocumentSnapshot cart) {
          return CartModel.fromJson(cart.data() as Map<String, dynamic>);
        }).toList();
        return result;
      });
    } catch (e) {
      throw Exception('Failed to get cart data');
    }
  }

  Future<void> addToCart({
    required UserModel user,
    required CartModel cart,
  }) async {
    try {
      firestore.collection('carts').add({
        'userId': user.id,
        'userName': user.name,
        'id': cart.id,
        'product': cart.product!.toJson(),
        'quantity': cart.quantity,
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }).then(
        (value) => print('Item successfully added to cart'),
      );
    } catch (e) {
      throw Exception('Failed to add item to cart');
    }
  }

  Future<void> updateCartItem({
    required String cartId,
    required int quantity,
  }) async {
    try {
      firestore.collection('carts').doc(cartId).update({
        'quantity': quantity,
        'updatedAt': DateTime.now().toString(),
      }).then(
        (value) => print('Cart item successfully updated'),
      );
    } catch (e) {
      throw Exception('Failed to update cart item');
    }
  }

  Future<void> removeFromCart({
    required String cartId,
  }) async {
    try {
      firestore.collection('carts').doc(cartId).delete().then(
            (value) => print('Item successfully removed from cart'),
          );
    } catch (e) {
      throw Exception('Failed to remove item from cart');
    }
  }

  Future<void> clearCart({
    required String userId,
  }) async {
    try {
      var cartSnapshots = await firestore
          .collection('carts')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in cartSnapshots.docs) {
        await doc.reference.delete();
      }
      print('Cart successfully cleared');
    } catch (e) {
      throw Exception('Failed to clear cart');
    }
  }
}
