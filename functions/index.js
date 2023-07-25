/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

/* eslint-disable no-unused-vars */
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
/* eslint-enable no-unused-vars */

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const admin = require('firebase-admin');
const functions = require('firebase-functions');
admin.initializeApp(functions.config().firebase);

const db = admin.firestore();

exports.updateAnn = functions.https.onCall((data, context) => {
  var tokens=[];

  const payload = {
    notification: {
      title: '공지사항 업데이트',
      body: `공지사항이 업데이트 되었습니다.`,
    },
  };
  // FireStore 에서 데이터 읽어오기
  db.collection('user').get().then((snapshot) => {
    snapshot.forEach((doc) => {
      if (doc.data().fcmToken!=null && doc.data().fcmToken!='' &&
        doc.data().fcmToken!=undefined) {
        tokens.push(doc.data().fcmToken);
      }
    });

    console.log(tokens);

    if (tokens.length > 0) {
      admin.messaging().sendToDevice(tokens, payload)
          .then((response) => {
            console.log('Successfully sent message:', response);
            return true;
          });
    }
    if (tokens.length==0) {
      console.log('Error getting documents');
      tokens.push('noData');
    }
    return tokens;
  })
      .catch((err) => {
        console.log('Error getting documents', err);
        tokens.push('Error getting documents');
        return tokens;
      });
});

// 문자가 온다면
exports.newAnn = functions.https.onCall((data, context) => {
  var tokens=[];

  const payload = {
    notification: {
      title: '새 공지사항',
      body: `새로운 공지사항이 있습니다.`,
    },
  };
  // FireStore 에서 데이터 읽어오기
  db.collection('user').get().then((snapshot) => {
    snapshot.forEach((doc) => {
      if (doc.data().fcmToken!=null && doc.data().fcmToken!='' &&
        doc.data().fcmToken!=undefined) {
        tokens.push(doc.data().fcmToken);
      }
    });

    console.log(tokens);

    if (tokens.length > 0) {
      admin.messaging().sendToDevice(tokens, payload)
          .then((response) => {
            console.log('Successfully sent message:', response);
            return true;
          });
    }
  })
      .catch((err) => {
        console.log('Error getting documents', err);
        return false;
      });

  return tokens;
});

exports.updateFAQ = functions.https.onCall((data, context) => {
  const payload = {
    notification: {
      title: '답변 업데이트',
      body: `답변이 업데이트 되었습니다.`,
    },
  };

  if (data.call!=null && data.call!='' &&
  data.call!=undefined) {
    db.collection('user').doc(data.call).get()
        .then((snapshot) => {
          console.log(snapshot.data().fcmToken);
          if (snapshot.data().fcmToken!=null && snapshot.data().fcmToken!='' &&
            snapshot.data().fcmToken!=undefined) {
            var token = snapshot.data().fcmToken;

            admin.messaging().sendToDevice(token, payload)
                .then((response) => {
                  console.log('Successfully sent message:', response);
                  return true;
                });
          }
        })
        .catch((err) => {
          console.log('Error getting documents', err);
          return false;
        });
  }
});
