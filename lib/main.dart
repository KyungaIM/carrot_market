import 'package:easy_localization/easy_localization.dart';
import 'package:fast_app_base/data/network/dangn_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';
import 'common/data/preference/app_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppPreferences.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ///객체생성
  DaangnApi();

  setLocaleMessages('ko', KoMessages());
  runApp(ProviderScope(
    child: EasyLocalization(
        supportedLocales: const [Locale('ko')],
        fallbackLocale: const Locale('ko'),
        path: 'assets/translations',
        useOnlyLangCode: true,
        child: const App()),
  ));
}