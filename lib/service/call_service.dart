import 'dart:io';

import 'package:call_0953_manager/service/file_picker_service.dart';
import 'package:call_0953_manager/service/mileage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../model/call.dart';
import '../model/mileage.dart';

class CallService {
  FirebaseDatabase database = FirebaseDatabase.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> excelToCall() async {
    try {
      final file = await FilePickerService().pickFile();
      if (file == null) return false;
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      bool a = true;

      await Future.wait(excel.tables.keys.map((e) async {
        for (var row in excel.tables[e]!.rows) {
          if (a) {
            a = false;
            continue;
          }
          final data = row.map((e) => e?.value);
          final orderNumber =
              '${data.elementAt(9)}${data.elementAt(10)}${data.elementAt(6)}'
                  .replaceAll('/', '');
          final call = Call(
              orderNumber: orderNumber,
              name: data.elementAt(3).toString(),
              call: data.elementAt(6).toString().replaceAll('-', ''),
              price: int.parse(data.elementAt(11).toString()),
              date: DateFormat('yyyy-').format(DateTime.now()) + data.elementAt(9).toString().replaceAll('/', '-'),
              time: data.elementAt(10).toString(),
              startAddress: data.elementAt(7).toString(),
              endAddress: data.elementAt(8).toString(),
              mileage: 1000,
              bonusMileage: 1000);
          await saveCall(call);
        }
      }));
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveCall(Call call) async {
    try {
      print('saving');
      await database
          .ref()
          .child('call')
          .child(call.orderNumber)
          .set(call.toJson())
          .timeout(Duration(seconds: 10),
              onTimeout: () => throw Exception('timeout'));

      // 날짜별로 콜 기록 저장
      final year = DateFormat('yyyy').format(DateTime.now());
      firestore
          .collection('call')
          .doc(call.date.substring(0, 7))
          .collection(call.date.substring(8, 10))
          .doc(call.orderNumber)
          .set({'call': call.orderNumber});

      saveMileage(call);
      print('saved');
    } catch (e) {
      print('error');
      throw Exception("saveCall: $e");
    }
  }

  Future<void> saveMileage(Call call) async {
    final Mileage mileage = Mileage(
        orderNumber: call.orderNumber,
        name: call.name,
        call: call.call,
        type: '콜',
        amount: 1000,
        date: call.date);
    MileageService().saveMileage(mileage);
    if (call.bonusMileage != null && call.bonusMileage != 0) {
      final Mileage bonusMileage = Mileage(
          orderNumber: call.orderNumber,
          name: call.name,
          call: call.call,
          type: '추가 마일리지',
          amount: call.bonusMileage!,
          date: call.date);
      MileageService().saveMileage(bonusMileage);
    }
  }

  Future<List<Call>> getCallForDate(String date) async {
    List<String> callNumberList = [];
    List<Call> callList = [];
    try {
      await firestore
          .collection('call')
          .doc('202302')
          .collection('25')
          .get()
          .then((value) {
        for (var element in value.docs) {
          callNumberList.add(element.data()['call']);
        }
      });
      await Future.wait(callNumberList.map((element) async {
        await database.ref().child('call').child(element).get().then((value) {
          callList.add(Call.fromDB(value.value));
        });
      }));
      return callList;
    } catch (e) {
      throw Exception("getCallRecord: $e");
    }
  }

  Future<List<Call>> getAllCall() async {
    List<Call> callList = [];
    try {
      await database.ref().child('call').get().then((value) {
        print(value.value);
        if (value.value == null) return;
        final Map<dynamic, dynamic> data = value.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          callList.add(Call.fromDB(value));
        });
      });
      return callList;
    } catch (e) {
      throw Exception("getCallRecord: $e");
    }
  }
}
