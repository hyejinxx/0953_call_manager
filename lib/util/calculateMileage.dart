
import 'dart:convert';

import 'package:flutter/services.dart';

Future<int> calMileage(String type, int amount) async {
  try{
  // type에 따라서 마일리지 계산
  if (type == '카드') {
    String cardData =
        await rootBundle.loadString('assets/json/cardMileage.json');
    Map<String, dynamic> json = jsonDecode(cardData);
    // 5000원 단위로 계산
    int price = (amount ~/ 5000) * 5000;
    if (price > 200000) {
      return json['200000'] ?? 0;
    } else if (price > 100000) {
      int price = (amount ~/ 50000) * 50000;
      return json[price.toString()] ?? 0;
    } else {
      try {
        return json[price.toString()] ?? 0;
      } catch (e) {
        return 0;
      }
    }
  } else {
    String cashData =
        await rootBundle.loadString('assets/json/cashMileage.json');
    Map<String, dynamic> json = jsonDecode(cashData);
    // 5000원 단위로 계산
    int price = (amount ~/ 5000) * 5000;
    if (price > 200000) {
      return json['200000'] ?? 0;
    } else if (price > 100000) {
      int price = (amount ~/ 50000) * 50000;
      return json[price.toString()] ?? 0;
    } else {
      try {
        return json[price.toString()] ?? 0;
      } catch (e) {
        return 0;
      }
    }
  }
  } catch (e) {
    print('catch!: $e');
    return 0;
  }
}
