import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/call.dart';
import '../model/mileage.dart';

class MileageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> callToMileage(Call call) async {
    final Mileage mileage = Mileage(
        name: call.name,
        call: call.call,
        type: 'call',
        amount: 1000,
        date: call.date ?? DateFormat('MM/dd').format(DateTime.now()));
    saveMileage(mileage);
    if(call.bonusMileage != null || call.bonusMileage != 0){
      final Mileage bonusMileage = Mileage(
          name: call.name,
          call: call.call,
          type: 'bonus',
          amount: call.bonusMileage!,
          date: call.date ?? DateFormat('MM/dd').format(DateTime.now()));
      saveMileage(bonusMileage);
    }
  }


  Future<void> saveMileage(Mileage mileage) async {
    try {
      // 유저 마일리지 기록 저장
      await firestore
          .collection('user')
          .doc(mileage.call)
          .collection('mileage')
          .doc(mileage.date)
          .set(mileage.toJson());
      // 유저 마일리지 업데이트
      await firestore
          .collection('user')
          .doc(mileage.call)
          .get()
          .then((value) async {
        int updatedMileage = value.data()!['mileage'] + mileage.amount;
        firestore
            .collection('user')
            .doc(mileage.call)
            .update({'mileage': updatedMileage});
      });
      // 관리자용 마일리지 기록 저장
      await database
          .ref()
          .child('mileage')
          .child(DateFormat('yy-MM').format(DateTime.now()))
          .child(mileage.date)
          .child(mileage.call)
          .set(mileage.toJson());
    } catch (e) {
      throw Exception("saveMileage: error");
    }
  }

  Future<List<Mileage>> getMileageRecordUser() async {
    List<Mileage> mileageList = [];
    final sharedPreferences = await SharedPreferences.getInstance();
    try {
      final user = sharedPreferences.getString('call');
      await firestore
          .collection('user')
          .doc(user)
          .collection('mileage')
          .get()
          .then((value) => value.docs.forEach((element) {
                mileageList.add(Mileage.fromJson(element.data()));
              }));
      return mileageList;
    } catch (e) {
      throw Exception("getMileageRecord: error");
    }
  }

  Future<List<Mileage>> getMileageRecordAll(
    String? date,
  ) async {
    List<Mileage> mileageList = [];
    // if(date != null){
    //   mileageList = database.ref().child('mileage').get()
    //
    //
    // }else{
    //   mileageList = database.ref().child('mileage').child(
    //       date!).get().then((value) => value.docs.forEach((element) {
    // }
    return mileageList;
  }
}
