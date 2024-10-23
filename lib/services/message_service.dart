import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/models/user_model.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addMessage(
      {UserModel? user,
      bool? isFromUser,
      String? message,
      ProductModel? product}) async {
    try {
      firestore.collection('messages').add({
        'message': message,
        'userId': user!.id,
        'userName': user.name,
        'userImage': user.profilePhotoUrl,
        'isFromUser': isFromUser,
        'product':
            product is UninitializedProductModel ? {} : product!.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }).then(
        (value) => print('Pesan Berhasil Dikirim'),
      );
    } catch (e) {
      throw Exception('Pesan Gagal Dikirim!');
    }
  }
}
