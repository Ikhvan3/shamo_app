import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shamo_app/models/order_model.dart';

class OrderService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // Mendapatkan pesanan berdasarkan user ID
  Stream<List<OrderModel>> getOrdersByUserId(String userId) {
    try {
      return firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        var result = list.docs.map<OrderModel>((DocumentSnapshot orderItem) {
          return OrderModel.fromJson(orderItem.data() as Map<String, dynamic>);
        }).toList();

        return result;
      });
    } catch (e) {
      throw Exception('Gagal mengambil pesanan');
    }
  }

  Future<void> addOrder({required User user, required OrderModel order}) async {
    try {
      await firestore.collection('orders').add({
        'userId': user.uid,
        'orderId': order.orderId,
        'items': order.items.map((item) => item.toJson()).toList(),
        'totalPrice': order.totalPrice,
        'status': order.status,
        'paymentMethod': order.paymentMethod,
        'orderDate': order.orderDate.toIso8601String(),
        'deliveryAddress': order.deliveryAddress,
      }).then((value) {
        print('Pesanan Berhasil Ditambahkan');
      });
    } catch (e) {
      throw Exception('Gagal Menambahkan Pesanan');
    }
  }

  // Menghapus pesanan dari Firestore
  Future<void> removeOrder(
      {required User user, required OrderModel order}) async {
    try {
      QuerySnapshot orderItems = await firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid) // Ganti id dengan uid
          .where('orderId', isEqualTo: order.orderId) // Ganti id dengan orderId
          .get();

      for (var doc in orderItems.docs) {
        await doc.reference.delete();
      }

      print('Pesanan Berhasil Dihapus');
    } catch (e) {
      throw Exception('Gagal Menghapus Pesanan');
    }
  }

  Future<bool> isOrderExists(
      {required User user, required OrderModel order}) async {
    try {
      QuerySnapshot orderItems = await firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid) // Ganti id dengan uid
          .where('orderId', isEqualTo: order.orderId) // Ganti id dengan orderId
          .get();

      return orderItems.docs.isNotEmpty;
    } catch (e) {
      print('Gagal memeriksa pesanan: $e');
      return false;
    }
  }
}
