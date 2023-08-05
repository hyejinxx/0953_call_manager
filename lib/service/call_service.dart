import 'dart:io';

import 'package:call_0953_manager/service/file_picker_service.dart';
import 'package:call_0953_manager/service/manager_service.dart';
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
  final url =
      'https://project-568166903627460027-default-rtdb.firebaseio.com/call.json';
  final urlNotUser =
      'https://project-568166903627460027-default-rtdb.firebaseio.com/notUser.json';

  Future<bool> excelToCall() async {
    try {
      final file = await FilePickerService().pickFile();
      if (file == null) return false;
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      bool isFirst = true;

      // 마일리지 기준 가져오기
      final cardStandard = await ManagerService().getMileageStandardForCard();
      final cashStandard = await ManagerService().getMileageStandardForCash();
      final cardBonusStandard =
          await ManagerService().getBonusMileageStandardForCard();
      final cashBonusStandard =
          await ManagerService().getBonusMileageStandardForCash();

      // 엑셀 파일의 시트마다 반복
      await Future.wait(excel.tables.keys.map((e) async {
        // 엑셀 파일의 첫번째 행(헤더)에서 각 열의 인덱스를 가져옴
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

        // 엑셀 파일의 각 행(데이터)마다 반복
        for (var row in excel.tables[e]!.rows) {
          if (isFirst) {
            isFirst = false;
            continue;
          }

          try {
            final data = row.map((e) => e?.value);
            if (data.elementAt(nameIndex) == null) continue;

            final orderNumber =
                '${data.elementAt(dateIndex)}${data.elementAt(timeIndex)}${data.elementAt(callIndex)}'
                    .replaceAll('/', '');

            // 마일리지 계산
            Call call = Call(
              orderNumber: orderNumber,
              name: data.elementAt(nameIndex).toString(),
              call: data.elementAt(callIndex).toString().replaceAll('-', ''),
              price: int.parse(
                  data.elementAt(priceIndex).toString().replaceAll(',', '')),
              date: DateFormat('yyyy-').format(DateTime.now()) +
                  data.elementAt(dateIndex).toString().replaceAll('/', '-'),
              time: data.elementAt(timeIndex).toString(),
              startAddress: data.elementAt(startAddressIndex).toString(),
              endAddress: data.elementAt(endAddressIndex).toString(),
              mileage: 0,
              bonusMileage: 0,
              sumMileage: 0,
            );

            User? user = await UserService().getUser(
                data.elementAt(callIndex).toString().replaceAll('-', ''));
            if (user != null) {
              final num = calMileage(int.parse(
                  data.elementAt(priceIndex).toString().replaceAll(',', '')));

              if (data.elementAt(cardIndex).toString().contains('결제완료')) {
                call.mileage = cardStandard['a$num'];
              } else {
                call.mileage = cashStandard['a$num'];
              }

              // 보너스 마일리지 계산
              if (data.elementAt(cardIndex).toString().contains('결제완료')) {
                call.bonusMileage = cardBonusStandard['a$num'];
              } else {
                call.bonusMileage = cashBonusStandard['a$num'];
              }

              call.sumMileage = call.mileage! + call.bonusMileage!;

              call.name = user.name;
            }

            if (user != null) {
              await saveCall(call);
            } else {
              await saveCallNotUser(call);
            }
            print('saved: $orderNumber');
          } catch (e) {
            print('save error: $e');

            continue;
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
      final a = await http.post(Uri.parse(url), body: jsonEncode(call));
      final callNum = jsonDecode(a.body)['name'];

      // 날짜별로 콜 기록 저장
      firestore
          .collection('call')
          .document(call.date.substring(0, 7))
          .collection(call.date.substring(8, 10))
          .document(callNum)
          .set({'call': callNum});

      firestore
          .collection('user')
          .document(call.call)
          .collection('call')
          .document(callNum)
          .set(call.toJson());

      saveMileage(call);
      print('saved');
    } catch (e) {
      print('error');
      throw Exception("saveCall: $e");
    }
  }

  Future<void> saveMileage(Call call) async {
    if (call.mileage != 0 && call.mileage != null) {
      final Mileage mileage = Mileage(
          orderNumber: call.orderNumber,
          name: call.name,
          call: call.call,
          type: '콜 적립',
          startAddress: call.startAddress ?? '',
          endAddress: call.endAddress ?? '',
          amount: call.mileage!,
          sumMileage: 0,
          date: call.date);
      await MileageService().saveMileage(mileage);
    }
    if (call.bonusMileage != null && call.bonusMileage != 0) {
      final Mileage bonusMileage = Mileage(
          orderNumber: call.orderNumber,
          name: call.name,
          call: call.call,
          type: '이벤트 적립',
          startAddress: call.startAddress ?? '',
          endAddress: call.endAddress ?? '',
          sumMileage: 0,
          amount: call.bonusMileage!,
          date: call.date);
      await MileageService().saveMileage(bonusMileage);
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
        if (jsonDecode(result.body) == null) return;
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
        print(value.body);
        if (jsonDecode(value.body) == null) return;
        final Map<String, dynamic> data =
            json.decode(value.body) as Map<String, dynamic>;
        data.forEach((key, value) {
          callList.add(Call.fromJson(value));
        });
      });

      await http.get(Uri.parse(urlNotUser)).then((value) {
        print(value.body);
        if (jsonDecode(value.body) == null) return;
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

  Future<List<Call>> getAllCallUser() async {
    List<Call> callList = [];
    try {
      await http.get(Uri.parse(url)).then((value) {
        print(value.body);
        if (jsonDecode(value.body) == null) return;
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

  Future<List<Call>> getCallForUser(String userCall) async {
    List<Call> callList = [];
    try {
      await firestore
          .collection('user')
          .document(userCall)
          .collection('call')
          .get()
          .then((value) => value.forEach((element) {
                callList.add(Call.fromJson(element.map));
              }));
      print(callList.length);
      return callList;
    } catch (e) {
      print(e);
      throw Exception("getCallForUserList: error");
    }
  }

  Future<void> saveCallNotUser(Call call) async {
    try {
      print('saving');
      final a = await http.post(Uri.parse(urlNotUser), body: jsonEncode(call));
      final callNum = jsonDecode(a.body)['name'];

      // // 날짜별로 콜 기록 저장
      // firestore
      //     .collection('callNotUser')
      //     .document(call.date.substring(0, 7))
      //     .collection(call.date.substring(8, 10))
      //     .document(callNum)
      //     .set({'call': callNum});

      print('saved');
    } catch (e) {
      print('error');
      throw Exception("saveCall: $e");
    }
  }

  Future<List<Call>> getAllCallNotUser() async {
    List<Call> callList = [];
    try {
      await http.get(Uri.parse(urlNotUser)).then((value) {
        print(value.body);
        if (jsonDecode(value.body) == null) return;
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

  Future<void> deleteAllCallNotUser() async {
    try {
      await http.delete(Uri.parse(urlNotUser)).then((value) {});
    } catch (e) {
      throw Exception("deleteAllCallNotUser: $e");
    }
  }

  Future<void> deleteAllCallUser() async {
    try {
      await http.delete(Uri.parse(url)).then((value) {});
      firestore.collection('call').get().then((value) {
        for (var element in value) {
          element.reference.delete();
        }
      });
    } catch (e) {
      throw Exception("deleteAllCallNotUser: $e");
    }
  }

  Future<void> callToExcel(List<Call> callList) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['비유저 콜'];
    CellStyle cellStyle = CellStyle(backgroundColorHex: "#1AFF1A");
    cellStyle.underline = Underline.Single;

    for (var call in callList) {
      sheetObject.appendRow([
        call.date,
        call.name,
        call.call,
        call.startAddress,
        call.endAddress,
        call.price
      ]);
    }
  }
}
