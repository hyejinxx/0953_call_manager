import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/login_service.dart';

class AuthProvider extends StateNotifier<User?> {
  AuthProvider() : super(FirebaseAuth.instance.currentUser);
  final socialLogin = SocialLoginService();

  @override
  set state(User? value) {
    //
    super.state = value;
  }
  signInWithGoogle() async {
    state = await socialLogin.signInWithGoogle();
  }

}
