import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../data/network/dangn_api.dart';
import '../../data/preference/prefs.dart';

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
Future<void> verifyFirebaseTokenAndInitJwtTokens() async {
  final idToken = await _auth.currentUser!.getIdToken();
  await DaangnApi.firebaseVerify(idToken!);
}

/// 구글 계정 사진
String? googlePhotoUrl() {
  final user = _auth.currentUser!;
  final googlePhotoUrl = user.providerData.firstWhere((e) => e.providerId == 'google.com').photoURL;
  return googlePhotoUrl ?? user.photoURL;
}

/// 로그아웃
Future<void> signOut() async {
    final osType = Platform.isAndroid ? '1' : '2'; // 운영체제 유형 (1: 안드로이드, 2: iOS)
    final authEmail = Prefs.userEmail.get() ?? '';
    await _auth.signOut();
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await Prefs.accessToken.delete();
    await Prefs.refreshToken.delete();
    await Prefs.isLoggedIn.set(false);

    await DaangnApi.logoutLogSave(authEmail, osType);
}
