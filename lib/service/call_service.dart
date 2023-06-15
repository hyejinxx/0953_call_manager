import 'dart:io';

import 'package:call_0953_manager/service/file_picker_service.dart';
import 'package:call_0953_manager/service/mileage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/call.dart';

class CallService{
  FirebaseDatabase database = FirebaseDatabase.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> excelToCall() async {
    try {
      final file = await FilePickerService().pickFile();
      if(file == null) return;
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      bool a = true;

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if(a){
            a = false;
            continue;
          }
          final data = row.map((e) => e?.value);
          final call = Call(orderNumber: '', name: data.elementAt(3).toString(), call: data.elementAt(6).toString().replaceAll('-', ''), price: int.parse(data.elementAt(11).toString()), date: data.elementAt(9).toString().replaceAll('/', '-'), time: data.elementAt(10).toString(), startAddress: data.elementAt(7).toString(), endAddress: data.elementAt(8).toString(), bonusMileage: 1000);
          saveCall(call);
        }
      }

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveCall(Call call) async {
    try {
      print('saving');
      // await firestore.collection('call').doc(DateFormat('MM-dd').format(DateTime.now())).collection('${call.time}-${call.call}').doc(call.call).set(call.toJson());
     await database.ref().child('call').child(
        call.date!).child('${call.time}-${call.call}').set(call.toJson()).timeout(Duration(seconds: 10), onTimeout: () => throw Exception('timeout'));
      print('saved');
      MileageService().callToMileage(call);
    } catch (e) {
      print('error');
      throw Exception("saveCall: $e");
    }
  }

}