import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/models/user_model.dart';

class WishlistService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // Mendapatkan wishlist berdasarkan user ID
  Stream<List<ProductModel>> getWishlistByUserId(int? userId) {
    try {
      return firestore
          .collection('wishlists')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        var result =
            list.docs.map<ProductModel>((DocumentSnapshot wishlistItem) {
          print(wishlistItem.data());
          return ProductModel.fromJson(
              wishlistItem.data() as Map<String, dynamic>);
        }).toList();

        return result;
      });
    } catch (e) {
      throw Exception('Gagal mengambil wishlist');
    }
  }

  // Menambahkan produk ke wishlist
  Future<void> addToWishlist(
      {required UserModel? user, required ProductModel? product}) async {
    try {
      // Cek apakah produk sudah ada di wishlist
      QuerySnapshot existingWishlist = await firestore
          .collection('wishlists')
          .where('userId', isEqualTo: user!.id)
          .where('id', isEqualTo: product!.id)
          .get();

      // Jika produk belum ada di wishlist, tambahkan
      if (existingWishlist.docs.isEmpty) {
        await firestore.collection('wishlists').add({
          'userId': user.id,
          'userName': user.name,
          'userEmail': user.email,
          // Tambahkan seluruh detail produk
          ...product.toJson(),
          'addedAt': DateTime.now().toString(),
        }).then(
          (value) => print('Produk Berhasil Ditambahkan ke Wishlist'),
        );
      }
    } catch (e) {
      throw Exception('Gagal Menambahkan ke Wishlist!');
    }
  }

  // Menghapus produk dari wishlist
  Future<void> removeFromWishlist(
      {required UserModel? user, required ProductModel? product}) async {
    try {
      // Cari dokumen wishlist yang sesuai
      QuerySnapshot wishlistItems = await firestore
          .collection('wishlists')
          .where('userId', isEqualTo: user!.id)
          .where('id', isEqualTo: product!.id)
          .get();

      // Hapus dokumen jika ditemukan
      for (var doc in wishlistItems.docs) {
        await doc.reference.delete();
      }

      print('Produk Berhasil Dihapus dari Wishlist');
    } catch (e) {
      throw Exception('Gagal Menghapus dari Wishlist!');
    }
  }

  // Memeriksa apakah produk ada di wishlist
  Future<bool> isInWishlist(
      {required UserModel? user, required ProductModel? product}) async {
    try {
      QuerySnapshot wishlistItems = await firestore
          .collection('wishlists')
          .where('userId', isEqualTo: user!.id)
          .where('id', isEqualTo: product!.id)
          .get();

      return wishlistItems.docs.isNotEmpty;
    } catch (e) {
      print('Gagal memeriksa wishlist: $e');
      return false;
    }
  }
}
