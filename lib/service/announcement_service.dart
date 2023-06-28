import 'dart:io';

import 'package:call_0953_manager/model/announcement.dart';
import 'package:call_0953_manager/model/faq.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firedart.dart';

class AnnouncementService {
  Firestore firestore = Firestore.instance;

  Future<void> saveAnnouncement(Announcement announcement) async {
    try {
      firestore
          .collection('announcement')
          .document(announcement.createdAt)
          .set(announcement.toJson());
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

  Future<List<FAQ>> getNewFAQ() async {
    try {
      List<FAQ> faq = [];
      await firestore
          .collection('faq')
          .document('faq')
          .collection('all')
          .get()
          .then((value) {
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

  deleteNewFAQ(String createdAt) async {
    try {
      await firestore
          .collection('faq')
          .document('faq')
          .collection('all')
          .document(createdAt)
          .delete();
      print('deleteNewFAQ: success');
    } catch (e) {
      print('deleteNewFAQ: $e');
      throw Exception("deleteNewFAQ: error");
    }
  }

  saveAnswerFAQ(FAQ faq) async {
    try {
      await firestore
          .collection('faq')
          .document('faq')
          .collection('all')
          .document(faq.createdAt)
          .update(faq.toJson());

      await firestore.collection('faq').document('faq').collection(faq.writer).document(faq.createdAt).update(faq.toJson());
      print('saveAnswerFAQ: success');
    } catch (e) {
      print('saveAnswerFAQ: $e');
      throw Exception("saveAnswerFAQ: error");
    }
  }
}
