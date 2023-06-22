import 'dart:convert';

import 'package:call_0953_manager/model/withdraw.dart';
import 'package:firedart/firedart.dart';
import 'package:http/http.dart' as http;

import '../model/mileage.dart';

class MileageService {
  Firestore firestore = Firestore.instance;
  final mileageUrl =
      'https://project-568166903627460027-default-rtdb.firebaseio.com/mileage.json';
  final withdrawUrl =
      'https://project-568166903627460027-default-rtdb.firebaseio.com/withdraw.json';

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
      final a = await http.post(Uri.parse(mileageUrl),
          body: jsonEncode(mileage));
      final mileageNum = jsonDecode(a.body)['name'];
      await firestore
          .collection('mileage')
          .document(mileage.date.substring(0, 7))
          .collection(mileage.date.substring(8, 10))
          .document(mileageNum)
          .set({'mileage': mileageNum});
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
      await firestore
          .collection('withdraw')
          .document(withdraw.createdAt + withdraw.userCall)
          .update({'status': status});
      // withdraw = Withdraw(
      //     name: withdraw.name,
      //     createdAt: withdraw.createdAt,
      //     account: withdraw.account,
      //     bank: withdraw.bank,
      //     userCall: withdraw.userCall,
      //     amount: withdraw.amount,
      //     status: status);
      // final a = await http.post(Uri.parse(withdrawUrl),
      //     body: {withdraw.createdAt + withdraw.userCall: jsonEncode( Withdraw(
      //         name: withdraw.name,
      //         createdAt: withdraw.createdAt,
      //         account: withdraw.account,
      //         bank: withdraw.bank,
      //         userCall: withdraw.userCall,
      //         amount: withdraw.amount,
      //         status: status))});
      // print(a.body);
    } catch (e) {
      throw Exception("saveWithdraw: $e");
    }
  }

  Future<List<Withdraw>> getWithdraw() async {
    List<Withdraw> withdrawList = [];
    try {
      await http.get(Uri.parse(withdrawUrl)).then((value) {
        if (jsonDecode(value.body) == null) return;
        final Map<dynamic, dynamic> data = jsonDecode(value.body) as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          withdrawList.add(Withdraw.fromDB(value));
        });
      });
      await Future.wait(withdrawList.map((e) async {
        await firestore
            .collection('withdraw')
            .document(e.createdAt + e.userCall)
            .get()
            .then((value) {
              e.status = value.map['status'];
        });
      }));
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
      await http.get(Uri.parse(mileageUrl)).then((value) {
        if (jsonDecode(value.body) == null) return;
        final Map<dynamic, dynamic> data = jsonDecode(value.body) as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          mileageIdList.add(key);
          mileageList.add(Mileage.fromDB(value));
        });
      });
      return mileageList;
    } catch (e) {
      throw Exception("getMileageRecord: $e");
    }
  }

  Future<List<Mileage>> getAllMileage() async {
    List<Mileage> mileageList = [];
    try {
      await http.get(Uri.parse(mileageUrl)).then((value) {
        if (jsonDecode(value.body) == null) return;
        print(value.body);

        final Map<dynamic, dynamic> data = jsonDecode(value.body) as Map<dynamic, dynamic>;
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
