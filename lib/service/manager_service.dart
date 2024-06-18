import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/services.dart';

class ManagerService {
  Firestore firestore = Firestore.instance;

  Future<Map<String, dynamic>> getCallNumber() async {
    try {
      final data = await firestore.collection('callNumber').document('callNumber').get();
      if (data == null) {
        return {'daeri': '0432160953', 'gisa': '01050160103', 'taksong': '01050160103'};
      } else {
        print(data!);
        return data.map;
      }
    } catch (e) {
      throw Exception("getCallNumber: error");
    }
  }

  Future<void> setCallNumber(Map<String, dynamic> number) async {
    try {
      await firestore.collection('callNumber').document('callNumber').update(number);
    } catch (e) {
      throw Exception("setCallNumber: error");
    }
  }

  Future<Map<String, dynamic>> getMileageStandardForCard() async {
    Map<String, dynamic> cardData = await firestore.collection('mileageStandard').document('standardCard').get().then((value) {
      return value.map;
    }).onError((error, stackTrace) async {
      var data = await rootBundle.loadString('assets/json/cashMileageStandard.json');
      return jsonDecode(data);
    });

    return Map.fromEntries(cardData.entries.toList()..sort((a, b) => int.parse(a.key.replaceAll('a', '')).compareTo(int.parse(b.key.replaceAll('a', '')))));
  }

  Future<Map<String, dynamic>> getMileageStandardForCash() async {
    try {
      Map<String, dynamic>? cashData = await firestore.collection('mileageStandard').document('standardCash').get().then((value) {
        return value.map;
      }).onError((error, stackTrace) async {
        var data = await rootBundle.loadString('assets/json/cashMileageStandard.json');
        return jsonDecode(data);
      });

      return Map.fromEntries(cashData.entries.toList()..sort((a, b) => int.parse(a.key.replaceAll('a', '')).compareTo(int.parse(b.key.replaceAll('a', '')))));
    } catch (e) {
      throw Exception("getMileageStandardForCash: error");
    }
  }

  Future<Map<String, dynamic>> getBonusMileageStandardForCard() async {
    Map<String, dynamic> cardData = await firestore.collection('mileageStandard').document('card').get().then((value) {
      return value.map;
    }).onError((error, stackTrace) async {
      var data = await rootBundle.loadString('assets/json/cashMileage.json');
      return jsonDecode(data);
    });

    return Map.fromEntries(cardData.entries.toList()..sort((a, b) => int.parse(a.key.replaceAll('a', '')).compareTo(int.parse(b.key.replaceAll('a', '')))));
  }

  Future<Map<String, dynamic>> getBonusMileageStandardForCash() async {
    try {
      Map<String, dynamic>? cashData = await firestore.collection('mileageStandard').document('cash').get().then((value) {
        return value.map;
      }).onError((error, stackTrace) async {
        var data = await rootBundle.loadString('assets/json/cashMileage.json');
        return jsonDecode(data);
      });

      return Map.fromEntries(cashData.entries.toList()..sort((a, b) => int.parse(a.key.replaceAll('a', '')).compareTo(int.parse(b.key.replaceAll('a', '')))));
    } catch (e) {
      throw Exception("getMileageStandardForCash: error");
    }
  }

  void updateMileageStandardForCash(Map<String, int> value) async {
    try {
      await firestore.collection('mileageStandard').document('standardCash').update(value);
    } catch (e) {
      throw Exception("updateMileageStandardForCash: $e");
    }
  }

  void updateMileageStandardForCard(Map<String, dynamic> value) async {
    try {
      await firestore.collection('mileageStandard').document('standardCard').update(value);
    } catch (e) {
      throw Exception("updateMileageStandardForCard: $e");
    }
  }

  void updateBonusMileageStandardForCash(Map<String, int> value) async {
    try {
      await firestore.collection('mileageStandard').document('cash').update(value);
    } catch (e) {
      throw Exception("updateMileageStandardForCash: $e");
    }
  }

  void updateBonusMileageStandardForCard(Map<String, dynamic> value) async {
    try {
      await firestore.collection('mileageStandard').document('card').update(value);
    } catch (e) {
      throw Exception("updateMileageStandardForCard: $e");
    }
  }
}
