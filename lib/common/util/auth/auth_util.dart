import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

/// 구글 로그인
Future<User?> signInWithGoogle() async {
  await _googleSignIn.signOut(); // 구글 계정 선택창 띄우기 위해
  final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
  if (googleAccount == null) throw PlatformException(code: 'sign_in_failed');
  final AuthCredential credential =
      await _authCredentialWithGoogle(googleAccount);
  User? user = await _firebaseSignInOrCreate(credential);
  return user;
}

/// 구글 인증으로 Firebase 의 AuthCredential 생성
Future<AuthCredential> _authCredentialWithGoogle(
    GoogleSignInAccount account) async {
  final GoogleSignInAuthentication authentication =
      await account.authentication;
  return GoogleAuthProvider.credential(
    accessToken: authentication.accessToken,
    idToken: authentication.idToken,
  );
}

/// Firebase 로그인, 만약 사용자가 계정이 없는 경우 자동으로 계정 생성 후 user 정보 return
Future<User?> _firebaseSignInOrCreate(AuthCredential credential) async {
  final UserCredential result = await _auth.signInWithCredential(credential);
  return result.user;
}

/// Firebase 토큰 검증
// Future<void> verifyFirebaseTokenAndInitJwtTokens() async {
//   final idToken = await _auth.currentUser!.getIdToken();
//   await DiaconnApsApi.firebaseVerify(idToken!);
// }

// /// 애플 로그인과 달리 구글은 로그인 중 사용자가 취소해도 예외가 발생하지 않으므로
// /// 계정 정보가 `null`일 경우 해당 예외를 던져 동일하게 처리
// class GoogleSignInCancelException implements Exception {
//   @override
//   String toString() {
//     return '$runtimeType: 구글 로그인 사용자 취소';
//   }
// }
//
// /// 구글 계정 사진
// String? googlePhotoUrl() {
//   final user = _auth.currentUser!;
//   final googlePhotoUrl = user.providerData.firstWhere((e) => e.providerId == 'google.com').photoURL;
//   return googlePhotoUrl ?? user.photoURL;
// }
//
// /// 로그아웃
// Future<void> signOut() async {
//   List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
//   if (connectivityResult.contains(ConnectivityResult.none)) {
//     showEzSnackBar(
//       icon: const WarningIcon(),
//       title: '네트워크 오류',
//       text: '네트워크를 연결해주세요.',
//       margin: const EdgeInsets.only(bottom: 76.0),
//     );
//     return;
//   } else {
//     await DiaconnApsApi.saveApsLog();
//     await Future.delayed(const Duration(milliseconds: 500));
//     final deviceInfo = await getDeviceInfo();
//     final osType = Platform.isAndroid ? '1' : '2'; // 운영체제 유형 (1: 안드로이드, 2: iOS)
//     final authEmail = SP.getString(SPKey.userEmail) ?? '';
//     await _auth.signOut();
//     if (await _googleSignIn.isSignedIn()) {
//       await _googleSignIn.signOut();
//     }
//     await SP.remove(SPKey.accessToken);
//     await SP.remove(SPKey.wizardState);
//     await DiaconnApsApi.logoutLogSave(authEmail, osType, deviceInfo);
//     LocalNotification.hideAll();
//     ForegroundService.notification('ez-Loop', 'ez-Loop를 원활히 동작시키기 위해 로그인을 해주세요.', 'assets/logo.png');
//     Fimber.d('로그아웃 처리 완료');
//     await Get.offAllNamed('/login');
//   }
// }
