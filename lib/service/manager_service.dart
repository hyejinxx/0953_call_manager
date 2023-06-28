import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ManagerService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getCallNumber() async {
    try {
      final data =
          await firestore.collection('callNumber').doc('callNumber').get();
      if (data.data() == null) {
        return {
          'daeri': '0432160953',
          'gisa': '01050160103',
          'taksong': '01050160103'
        };
      } else {
        print(data.data()!);
        return data.data()!;
      }
    } catch (e) {
      throw Exception("getCallNumber: error");
    }
  }

  Future<void> setCallNumber(Map<String, dynamic> number) async {
    try {
      await firestore.collection('callNumber').doc('callNumber').update(number);
    } catch (e) {
      throw Exception("setCallNumber: error");
    }
  }

  Future<Map<String, dynamic>?> getMileageStandardForCard() async {
    Map<String, dynamic>? cardData = await firestore
        .collection('mileageStandard')
        .doc('card')
        .get()
        .then((value) {
      return value.data();
    }).onError((error, stackTrace) async {
      var data = await rootBundle.loadString('assets/json/cashMileage.json');
      return jsonDecode(data);
    });

    return cardData;
  }

  Future<Map<String, dynamic>> getMileageStandardForCash() async {
    try {
      Map<String, dynamic>? cashData = await firestore
          .collection('mileageStandard')
          .doc('cash')
          .get()
          .then((value) {
        return value.data();
      }).onError((error, stackTrace) async {
        var data = await rootBundle.loadString('assets/json/cashMileage.json');
        return jsonDecode(data);
      });

      return cashData!;
    } catch (e) {
      throw Exception("getMileageStandardForCash: error");
    }
  }

  void updateMileageStandardForCash(Map<String, dynamic> value) async {
    try {
      await firestore.collection('mileageStandard').doc('cash').update(value);
    } catch (e) {
      throw Exception("updateMileageStandardForCash: error");
    }
  }

  void updateMileageStandardForCard(Map<String, dynamic> value) async {
    try {
      await firestore.collection('mileageStandard').doc('card').update(value);
    } catch (e) {
      throw Exception("updateMileageStandardForCard: error");
    }
  }
}
