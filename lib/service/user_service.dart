import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

import '../model/user.dart';

class UserService {
  Firestore firestore = Firestore.instance;

  Future<List<User>> getAllUser() async {
    List<User> userList = [];
    try {
      await firestore.collection('user').get().then((value) {
        value.forEach((element) {
          userList.add(User.fromJson(element.map));
        });
      });
      return userList;
    } catch (e) {
      throw Exception("getMileageRecord: $e");
    }
  }

  Future<User?> getUser(String userCall) async {
    try {
      final data = await firestore.collection('user').document(userCall).get();
      if (data.map.isNotEmpty && data!= null) {
        print(User.fromJson(data.map!));
        return User.fromJson(data.map!);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> editUser(Map<String, dynamic> data) async {
    try {
      await firestore.collection('user').document(data['call']).update(data);
    } catch (e) {
      throw Exception("editUser: $e");
    }
  }
  Future<void> deleteUser(String userCall) async {
    try {
      await firestore.collection('user').document(userCall).delete();
      firestore.collection('user').document('mileage').delete();

    } catch (e) {
      throw Exception("deleteUser: $e");
    }
  }
}
