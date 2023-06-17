import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/call.dart';
import '../model/mileage.dart';

class MileageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> saveMileage(Mileage mileage) async {
    try {
      // 유저 마일리지 기록 저장
      await firestore
          .collection('user')
          .doc(mileage.call)
          .collection('mileage')
          .doc(mileage.orderNumber + mileage.type)
          .set(mileage.toJson());
      // 유저 마일리지 업데이트
      await firestore
          .collection('user')
          .doc(mileage.call)
          .get()
          .then((value) async {
        if (value.data() != null) {
          int updatedMileage = value.data()!['mileage'] + mileage.amount;
          await firestore
              .collection('user')
              .doc(mileage.call)
              .update({'mileage': updatedMileage});
        }
      });
      // 관리자용 마일리지 기록 저장
      await database
          .ref()
          .child('mileage')
          .child(mileage.orderNumber + mileage.type)
          .set(mileage.toJson());

      final year = DateFormat('yyyy').format(DateTime.now());

      firestore
          .collection('mileage')
          .doc(year + mileage.date.substring(0, 2))
          .collection(mileage.date.substring(3, 5))
          .doc(mileage.orderNumber + mileage.type)
          .set({'mileage': mileage.orderNumber + mileage.type});
    } catch (e) {
      throw Exception("saveMileage: $e");
    }
  }

  Future<List<Mileage>> getMileageRecordUser(String userCall) async {
    List<Mileage> mileageList = [];
    try {
      await firestore
          .collection('user')
          .doc(userCall)
          .collection('mileage')
          .get()
          .then((value) => value.docs.forEach((element) {
                mileageList.add(Mileage.fromJson(element.data()));
              }));
      print(mileageList.length);
      return mileageList;
    } catch (e) {
     print(e);
      throw Exception("getMileageRecord: error");
    }
  }

  Future<List<Mileage>> getMileageForDate(String? date) async {
    List<String> mileageIdList = [];
    List<Mileage> mileageList = [];
    try {
      await firestore
          .collection('mileage')
          .doc('202302')
          .collection('25')
          .get()
          .then((value) {
        for (var element in value.docs) {
          mileageIdList.add(element.data()['mileage']);
        }
      });
      await Future.wait(mileageIdList.map((element) async {
        await database
            .ref()
            .child('mileage')
            .child(element)
            .get()
            .then((value) {
          mileageList.add(Mileage.fromDB(value.value));
        });
      }));
      return mileageList;
    } catch (e) {
      throw Exception("getMileageRecord: $e");
    }
  }
  Future<List<Mileage>> getAllMileage() async {
    List<Mileage> mileageList = [];
    try {
      await database.ref().child('mileage').get().then((value) {
        print(value.value);
        if(value.value == null) return;
        final Map<dynamic, dynamic> data = value.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          mileageList.add(Mileage.fromDB(value));
        });
      });
      return mileageList;
    } catch (e) {
      throw Exception("getMileageRecord: $e");
    }
  }
}
