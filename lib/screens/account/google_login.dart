import 'package:firebase_auth/firebase_auth.dart'
    as firebaseAuth; // firebase_auth에 별칭 부여
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 구글 로그인 메서드
  Future<firebaseAuth.User?> signInWithGoogle() async {
    // firebaseAuth.User 사용
    try {
      // 구글 로그인 요청
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // 로그인 취소 시

      // 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase 자격 증명 생성
      final firebaseAuth.AuthCredential credential =
          firebaseAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      final firebaseAuth.UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("구글 로그인 실패: $e");
      return null;
    }
  }

  // 로그아웃 메서드
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
