import 'package:call_0953_manager/model/withdraw.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firedart/firedart.dart';

import '../model/mileage.dart';

class MileageService {
  Firestore firestore = Firestore.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> saveMileage(Mileage mileage) async {
    try {
      // 유저 마일리지 기록 저장
      await firestore
          .collection('user')
          .document(mileage.call)
          .collection('mileage')
          .document(mileage.orderNumber + mileage.type)
          .set(mileage.toJson());
      // 유저 마일리지 업데이트
      await firestore
          .collection('user')
          .document(mileage.call)
          .get()
          .then((value) async {
        if (value.map != null) {
          int updatedMileage = value.map['mileage'] + mileage.amount;
          await firestore
              .collection('user')
              .document(mileage.call)
              .update({'mileage': updatedMileage});
        }
      });
      // 관리자용 마일리지 기록 저장
      await database
          .ref()
          .child('mileage')
          .child(mileage.orderNumber + mileage.type)
          .set(mileage.toJson());

      await firestore
          .collection('mileage')
          .document(mileage.date.substring(0, 7))
          .collection(mileage.date.substring(8, 10))
          .document(mileage.orderNumber + mileage.type)
          .set({'mileage': mileage.orderNumber + mileage.type});
    } catch (e) {
      throw Exception("saveMileage: $e");
    }
  }

  // 마일리지 출금 완료 처리
  Future<void> updateWithdraw(Withdraw withdraw, String status) async {
    try {
      // 유저 마일리지 기록 저장 -> 출금
      await firestore
          .collection('user')
          .document(withdraw.userCall)
          .collection('mileage')
          .document(withdraw.createdAt + withdraw.userCall)
          .update({'type': status});
      if (status == "출금완료") {
        // 유저 마일리지 업데이트
        await firestore
            .collection('user')
            .document(withdraw.userCall)
            .get()
            .then((value) async {
          if (value != null) {
            int updatedMileage = value.map['mileage'] - withdraw.amount;
            await firestore
                .collection('user')
                .document(withdraw.userCall)
                .update({'mileage': updatedMileage});
          }
        });
      }
      // 관리자용 출금 기록 저장
      await database
          .ref()
          .child('withdraw')
          .child(withdraw.createdAt + withdraw.userCall)
          .update({'status': status});
    } catch (e) {
      throw Exception("saveWithdraw: $e");
    }
  }

  Future<List<Withdraw>> getWithdraw() async {
    List<Withdraw> withdrawList = [];
    try {
      await database.ref().child('withdraw').get().then((value) {
        if (value.value == null) return;
        final Map<dynamic, dynamic> data = value.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          withdrawList.add(Withdraw.fromDB(value));
        });
      });
      return withdrawList;
    } catch (e) {
      print(e);
      throw Exception("getWithdraw: $e");
    }
  }

  Future<List<Mileage>> getMileageRecordUser(String userCall) async {
    List<Mileage> mileageList = [];
    try {
      await firestore
          .collection('user')
          .document(userCall)
          .collection('mileage')
          .get()
          .then((value) => value.forEach((element) {
                mileageList.add(Mileage.fromJson(element.map));
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
          .document('202302')
          .collection('25')
          .get()
          .then((value) {
        for (var element in value) {
          mileageIdList.add(element.map['mileage']);
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
        if (value.value == null) return;
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
