import 'package:call_0953_manager/service/file_picker_service.dart';
import 'package:call_0953_manager/service/mileage_service.dart';
import 'package:call_0953_manager/service/user_service.dart';
import 'package:call_0953_manager/util/calculateMileage.dart';
import 'package:excel/excel.dart';
import 'package:firedart/firedart.dart';
import 'package:intl/intl.dart';
import '../model/call.dart';
import '../model/mileage.dart';
import '../model/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CallService {
  Firestore firestore = Firestore.instance;
  final url = 'https://project-568166903627460027-default-rtdb.firebaseio.com/call.json';

  Future<bool> excelToCall() async {
    try {
      final file = await FilePickerService().pickFile();
      if (file == null) return false;
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      bool isFirst = true;

      await Future.wait(excel.tables.keys.map((e) async {
        final nameIndex = excel.tables[e]!.rows.first.indexOf(excel
            .tables[e]!.rows.first
            .where((element) => element?.value.toString() == '고객명')
            .elementAt(0));
        final callIndex = excel.tables[e]!.rows.first.indexOf(excel
            .tables[e]!.rows.first
            .where((element) => element?.value.toString() == '고객전화')
            .elementAt(0));
        final priceIndex = excel.tables[e]!.rows.first.indexOf(excel
            .tables[e]!.rows.first
            .where((element) => element?.value.toString() == '요금')
            .elementAt(0));
        final dateIndex = excel.tables[e]!.rows.first.indexOf(excel
            .tables[e]!.rows.first
            .where((element) => element?.value.toString() == '날짜')
            .elementAt(0));
        final timeIndex = excel.tables[e]!.rows.first.indexOf(excel
            .tables[e]!.rows.first
            .where((element) => element?.value.toString() == '시간')
            .elementAt(0));
        final startAddressIndex = excel.tables[e]!.rows.first.indexOf(excel
            .tables[e]!.rows.first
            .where((element) => element?.value.toString() == '출발지')
            .elementAt(0));
        final endAddressIndex = excel.tables[e]!.rows.first.indexOf(excel
            .tables[e]!.rows.first
            .where((element) => element?.value.toString() == '도착지')
            .elementAt(0));
        final cardIndex = excel.tables[e]!.rows.first.indexOf(excel
            .tables[e]!.rows.first
            .where((element) => element?.value.toString() == '카드')
            .elementAt(0));

        for (var row in excel.tables[e]!.rows) {
          if (isFirst) {
            isFirst = false;
            continue;
          }
          final data = row.map((e) => e?.value);

          User? user = await UserService().getUser(
              data.elementAt(callIndex).toString().replaceAll('-', ''));
          if (user != null) {
            print('user: ${user.name}');
            final orderNumber =
                '${data.elementAt(dateIndex)}${data.elementAt(timeIndex)}${data.elementAt(callIndex)}'
                    .replaceAll('/', '');
            final bonusMileage = await calMileage(
                data.elementAt(cardIndex).toString().contains('카드')
                    ? '카드'
                    : '현금',
              int.parse(data.elementAt(priceIndex).toString()));

            final call = Call(
                orderNumber: orderNumber,
                name: data.elementAt(nameIndex).toString(),
                call: data.elementAt(callIndex).toString().replaceAll('-', ''),
                price: int.parse(data.elementAt(priceIndex).toString()),
                date: DateFormat('yyyy-').format(DateTime.now()) +
                    data.elementAt(dateIndex).toString().replaceAll('/', '-'),
                time: data.elementAt(timeIndex).toString(),
                startAddress: data.elementAt(startAddressIndex).toString(),
                endAddress: data.elementAt(endAddressIndex).toString(),
                mileage: 1000,
                bonusMileage: bonusMileage);
            print(call);
            await saveCall(call);
          }
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
      await http.post(Uri.parse(url), body: {call.orderNumber: call.toJson()});

      // 날짜별로 콜 기록 저장
      firestore
          .collection('call')
          .document(call.date.substring(0, 7))
          .collection(call.date.substring(8, 10))
          .document(call.orderNumber)
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
          .document('202302')
          .collection('25')
          .get()
          .then((value) {
        for (var element in value) {
          callNumberList.add(element.map['call']);
        }
      });
      await Future.wait(callNumberList.map((element) async {
        final result = await http.get(Uri.parse(url));
        final Map<String, dynamic> data =
            json.decode(result.body) as Map<String, dynamic>;
        callList.add(Call.fromJson(data[element]));
      }));
      return callList;
    } catch (e) {
      throw Exception("getCallRecord: $e");
    }
  }

  Future<List<Call>> getAllCall() async {
    List<Call> callList = [];
    try {
      await http.get(Uri.parse(url)).then((value) {
        final Map<String, dynamic> data =
            json.decode(value.body) as Map<String, dynamic>;
        data.forEach((key, value) {
          callList.add(Call.fromJson(value));
        });
      });
      return callList;
    } catch (e) {
      throw Exception("getCallRecord: $e");
    }
  }
}
