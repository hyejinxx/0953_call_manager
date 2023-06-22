import 'dart:io';

import 'package:call_0953_manager/model/announcement.dart';
import 'package:call_0953_manager/model/faq.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firedart.dart';

class AnnouncementService{
  Firestore firestore = Firestore.instance;
  // Reference storage = FirebaseStorage.instance.ref().child("images");/**/

  Future<void> saveAnnouncement(Announcement announcement) async {
    try {
      firestore.collection('announcement').document('announcement').set({'announcement': announcement});
    } catch (e) {
      throw Exception("saveAnnouncement: error");
    }
  }

  Future<List<Announcement>> getAnnouncement() async {
    try {
      Announcement announcement;
      await firestore.collection('announcement').document('announcement').get().then((value) {
        announcement = Announcement.fromJson(value.map['announcement']);
      });
      return [];
    } catch (e) {
      throw Exception("getAnnouncement: error");
    }
  }

  Future<void> saveFAQ(FAQ faq) async {
    try {
      firestore.collection('faq').document('faq').set({'faq': faq});
    } catch (e) {
      throw Exception("saveFAQ: error");
    }
  }

  Future<List<FAQ>> getFAQ() async {
    try {
      FAQ faq;
      await firestore.collection('faq').document('faq').get().then((value) {
        faq = FAQ.fromJson(value.map['faq']);
      });
      return [];
    } catch (e) {
      throw Exception("getFAQ: error");
    }
  }

  // Future<String> uploadImage(String name, File file) async {
  //   try {
  //     final pathRef = storage.child(name);
  //     UploadTask task = pathRef.putFile(file);
  //
  //     await task.whenComplete(() => print('upload complete'));
  //     return await pathRef.getDownloadURL();
  //   } catch (e) {
  //     print('err: $e');
  //     return "err";
  //   }
  // }
}