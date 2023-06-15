import 'dart:io';

import 'package:call_0953_manager/service/file_picker_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

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

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          final data = row.map((e) => e?.value);
          final call = Call(orderNumber: '', name:  data.elementAt(3).toString(), call: data.elementAt(2).toString(), price: 3000);
          print(call);
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
        DateFormat('MM-dd').format(DateTime.now())).child('${call.time}-${call.call}').set(call.toJson()).timeout(Duration(seconds: 10), onTimeout: () => throw Exception('timeout'));
      print('saved');
    } catch (e) {
      print('error');
      throw Exception("saveCall: $e");
    }
  }

}