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
  Future<User?> getUser(String userCall) async {
    User? user;
    try {
      await firestore.collection('user').doc(userCall).get().then((value) {
        if(!value.exists && value.data() != null) throw Exception("User not found");
        user = User.fromJson(value.data()!);
      });
      return user;
    } catch (e) {
      throw Exception("getUser: $e");
    }
  }
}