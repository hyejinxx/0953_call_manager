import 'dart:convert';

import 'package:call_0953_manager/model/announcement.dart';
import 'package:call_0953_manager/model/faq.dart';
import 'package:firedart/firedart.dart';
import 'package:http/http.dart' as http;

class AnnouncementService {
  Firestore firestore = Firestore.instance;

  final pushFcmUrl = 'https://us-central1-project-568166903627460027.cloudfunctions.net/pushFcm';

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
          if (i.map['popUp'] == null) {
            announcement.add(Announcement.fromJson(i.map));
          }
        });
      });
      return announcement;
    } catch (e) {
      print('getAnnouncement: $e');
      throw Exception("getAnnouncement: $e");
    }
  }

  Future<String> getPopUpAnnouncement() async {
    try {
      String announcement = '';
      await firestore
          .collection('announcement')
          .document('popUp')
          .get()
          .then((value) {
        if (value.map['popUp'] != null) {
          announcement = value.map['popUp'];
        }
      });
      return announcement;
    } catch (e) {
      print('getAnnouncement: $e');
      throw Exception("getAnnouncement: $e");
    }
  }

  Future<void> savePopUpAnnouncement(String announcement) async {
    try {
      firestore
          .collection('announcement')
          .document('popUp')
          .set({'popUp': announcement});
      print('saveAnnouncement: success');
    } catch (e) {
      print('saveAnnouncement: $e');
      throw Exception("saveAnnouncement: $e");
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
  Future<void> pushFCM(bool update) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(update ? '$pushFcmUrl/updateAnn' : '$pushFcmUrl/newAnn'),
        headers: <String, String>{
          'Content-Type': 'application/X-www-form-urlencoded',
        },
      );

      print('pushFCM: success');
      print(response.body);
      print(response..toString());
    } catch (e) {
      print('pushFAQ: ${e}');
      throw Exception("pushFAQ: $e");
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

  Future deleateAnn(String createdAt) async {
    try {
      await firestore.collection('announcement').document(createdAt).delete();
    } catch (e) {
      print('deleateAnn: $e');
      throw Exception("deleateAnn: error");
    }
  }

  Future deleateFAQ(String createdAt) async {
    try {
      await firestore.collection('faq').document(createdAt).delete();
    } catch (e) {
      print('deleateAnn: $e');
      throw Exception("deleateAnn: error");
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

  deleteNewFAQ(FAQ faq) async {
    try {
      await firestore
          .collection('faq')
          .document('faq')
          .collection('all')
          .document(faq.createdAt)
          .delete();

      await firestore
          .collection('faq')
          .document('faq')
          .collection(faq.writer)
          .document(faq.createdAt)
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

      await firestore
          .collection('faq')
          .document('faq')
          .collection(faq.writer)
          .document(faq.createdAt)
          .update(faq.toJson());
      print('saveAnswerFAQ: success');
    } catch (e) {
      print('saveAnswerFAQ: $e');
      throw Exception("saveAnswerFAQ: error");
    }
  }

  Future<void> pushAnswer(String callNum) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$pushFcmUrl/newAnswer'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'call': callNum}),
      );
      print('pushFCM: success');
      print(response.statusCode);
      print(response.toString());
    } catch (e) {
      print('pushFAQ: $e');
      throw Exception("pushFAQ: $e");
    }
  }
}
