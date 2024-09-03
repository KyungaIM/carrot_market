import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/data/preference/item/preference_item.dart';
import 'package:fast_app_base/screen/main/s_main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/util/auth/auth_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Stack(
        children: [
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      '$basePath/logo.png',
                      width: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '당근마켓',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // Buttons
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        User? user = await signInWithGoogle();
                        if(user != null && mounted) {
                          PreferenceItem('isLoggedIn',false).set(true);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen()));
                        }
                      } catch (error) {
                        if (kDebugMode) {
                          print(error);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                    ),
                    child: '구글 로그인'.text.bold.make(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
