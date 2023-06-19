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
    try {
      final data = await firestore.collection('user').doc(userCall).get();
      if (data.exists && data.data() != null) {
        print(User.fromJson(data.data()!));
        return User.fromJson(data.data()!);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> editUser(Map<String, dynamic> data) async {
    try {
      await firestore.collection('user').doc(data['call']).update(data);
    } catch (e) {
      throw Exception("editUser: $e");
    }
  }
  Future<void> deleteUser(String userCall) async {
    try {
      await firestore.collection('user').doc(userCall).delete();
      firestore.collection('user').doc('mileage').delete();

    } catch (e) {
      throw Exception("deleteUser: $e");
    }
  }
}
