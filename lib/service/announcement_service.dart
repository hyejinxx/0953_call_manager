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
      print('saveAnnouncement: success');
    } catch (e) {
      print('saveAnnouncement: $e');
      throw Exception("saveAnnouncement: $e");
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
      print('getAnnouncement: $e');
      throw Exception("getAnnouncement: $e");
    }
  }

  Future<void> saveFAQ(FAQ faq) async {
    try {
      firestore.collection('faq').document(faq.createdAt).set(faq.toJson());
      print('saveFAQ: success');
    } catch (e) {
      print('saveFAQ: $e');
      throw Exception("saveFAQ: $e");
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
      print('getFAQ: success');
      return faq;
    } catch (e) {
      print('getFAQ: $e');
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