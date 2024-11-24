// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shamo_app/models/product_model.dart';
// import 'package:shamo_app/models/gallery_model.dart';

// class WishlistService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Menambahkan produk ke wishlist
//   Future<void> addToWishlist(String userId, ProductModel product) async {
//     try {
//       // Convert galleries ke format yang bisa disimpan di Firestore
//       List<Map<String, dynamic>> galleriesData = product.galleries
//               ?.map((gallery) => {
//                     'id': gallery.id,
//                     'url': gallery.url,
//                   })
//               .toList() ??
//           [];

//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('wishlist')
//           .doc(product.id.toString())
//           .set({
//         'id': product.id,
//         'name': product.name,
//         'price': product.price,
//         'description': product.description,
//         'category': product.category,
//         'galleries': galleriesData, // Simpan sebagai List<Map>
//         'createdAt': DateTime.now().toString(),
//       });
//     } catch (e) {
//       throw Exception('Gagal menambahkan ke wishlist: $e');
//     }
//   }

//   // Mengambil semua produk wishlist user
//   Stream<List<ProductModel>> getWishlist(String userId) {
//     return _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('wishlist')
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         Map<String, dynamic> data = doc.data();

//         // Convert galleries data kembali ke List<GalleryModel>
//         List<GalleryModel> galleries = (data['galleries'] as List)
//             .map((galleryData) => GalleryModel(
//                   id: galleryData['id'],
//                   url: galleryData['url'],
//                 ))
//             .toList();

//         return ProductModel(
//           id: data['id'],
//           name: data['name'],
//           price: data['price'],
//           description: data['description'],
//           category: data['category'],
//           galleries: galleries,
//         );
//       }).toList();
//     });
//   }

//   // Menghapus produk dari wishlist
//   Future<void> removeFromWishlist(String userId, String productId) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('wishlist')
//           .doc(productId)
//           .delete();
//     } catch (e) {
//       throw Exception('Gagal menghapus dari wishlist: $e');
//     }
//   }

//   // Mengecek apakah produk ada di wishlist
//   Future<bool> isInWishlist(String userId, String productId) async {
//     try {
//       final doc = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('wishlist')
//           .doc(productId)
//           .get();
//       return doc.exists;
//     } catch (e) {
//       throw Exception('Gagal mengecek wishlist: $e');
//     }
//   }
// }
