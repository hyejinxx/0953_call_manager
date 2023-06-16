import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<User>> getAllUser() async {
    List<User> userList = [];
    try {
      await firestore.collection('user').get().then((value) {
        value.docs.forEach((element) {
          userList.add(User.fromJson(element.data()));
        });
      });
      return userList;
    } catch (e) {
      throw Exception("getMileageRecord: $e");
    }
  }
}