import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginService {
  static final SocialLoginService _socialLoginService =
      SocialLoginService._internal();

  factory SocialLoginService() {
    return _socialLoginService;
  }

  SocialLoginService._internal();

  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (result.user != null) {
      return result.user;
    } else {
      return null;
    }
  }
}
