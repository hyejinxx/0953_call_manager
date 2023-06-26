import 'package:call_0953_manager/scenario/start/update_call_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const apiKey = 'AIzaSyADBYgb9OSleC_PTd0UPuy1Er8CqvucXcw';
const authDomain = 'project-568166903627460027.firebaseapp.com';
const projectId = 'project-568166903627460027';
const messagingSenderId = '411765918979';
const appId = '1:411765918979:web:98b08e864a6395a24f6d36';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
     apiKey: apiKey,
     authDomain: authDomain,
     projectId: projectId, appId: appId, messagingSenderId: messagingSenderId,
   ));
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  Firestore.initialize(projectId);
  
  FirebaseAuth.initialize(apiKey, await VolatileStore());
  FirebaseAuth.instance.signIn('lin019@naver.com', 'wls1110');

  //await auth.FirebaseAuth.instance
   //   .signInWithEmailAndPassword(
    //      email: 'lin019@naver.com', password: 'wls1110')
     // .then((value) => print('ok')).catchError((e){print('error: $e');});

  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: UpdateCallScreen());
  }
}
