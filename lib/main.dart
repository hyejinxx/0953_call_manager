import 'package:call_0953_manager/scenario/start/update_call_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

const apiKey = 'AIzaSyADBYgb9OSleC_PTd0UPuy1Er8CqvucXcw';
const authDomain = 'project-568166903627460027.firebaseapp.com';
const projectId = 'project-568166903627460027';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "project",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: 'lin019@naver.com', password: 'wls1110')
      .then((value) => print('ok')).catchError((e){print('error: $e');});

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
