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
      firestore.collection('announcement').document(announcement.createdAt).set(announcement.toJson());
    } catch (e) {
      throw Exception("saveAnnouncement: error");
    }
  }

  Future<List<Announcement>> getAnnouncement() async {
    try {
      List<Announcement> announcement = [];
      await firestore.collection('announcement').get().then((value) {
        value.forEach((i) {
          announcement.add(Announcement.fromJson(i.map));
        });
      });
      return announcement;
    } catch (e) {
      throw Exception("getAnnouncement: error");
    }
  }

  Future<void> saveFAQ(FAQ faq) async {
    try {
      firestore.collection('faq').document('faq').set(faq.toJson());
    } catch (e) {
      throw Exception("saveFAQ: error");
    }
  }

  Future<List<FAQ>> getFAQ() async {
    try {
      List<FAQ> faq = [];
      await firestore.collection('faq').get().then((value) {
        value.forEach((i) {
          faq.add(FAQ.fromJson(i.map));
        });
      });
      return faq;
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