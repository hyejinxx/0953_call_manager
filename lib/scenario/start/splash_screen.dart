import 'package:call_0953_manager/scenario/start/update_call_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/auth_provider.dart';

final authProvider = StateNotifierProvider.autoDispose<AuthProvider, User?>(
    (ref) => AuthProvider());

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  // 로딩페이지와 동시에 사용
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState != null) {
      toMainScreen();
    }

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: [
            const _Header(),
            LoginButton(
                onClicked: () {
                  ref.read(authProvider.notifier).signInWithGoogle();
                },
                assetPath: "assets/image/btn_google_login.png")
          ],
        ));
  }

  void toMainScreen() {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const UpdateCallScreen()),
          (route) => false);
    }
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(
        image: AssetImage('assets/image/0953.gif'),
        width: 350,
        height: 350,
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton(
      {super.key, required this.onClicked, required this.assetPath});

  final Function() onClicked;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 70.0,
        child: Card(
            elevation: 0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            margin: const EdgeInsets.only(top: 10),
            child: InkWell(
                onTap: onClicked,
                child: Ink.image(
                  fit: BoxFit.fitHeight,
                  image: AssetImage(assetPath),
                ))));
  }
}
