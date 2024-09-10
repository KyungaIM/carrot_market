import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/common/dart/extension/snackbar_context_extension.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_dangn_button.riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';

class FcmManager{
  static void requestPermission (){
    FirebaseMessaging.instance.requestPermission();
  }

  static void initialize(WidgetRef ref) async {
    ///forground
    FirebaseMessaging.onMessage.listen((message) async {
      final title = message.notification?.title;
      if(title == null){
        return;
      }
      ref.read(floatingButtonStateProvider.notifier).hideButton();
      App.navigatorKey.currentContext?.showSnackbar(title);
      await sleepAsync(4.seconds);
      ref.read(floatingButtonStateProvider.notifier).showButton();
    });

    final token = await FirebaseMessaging.instance.getToken();
    print(token);
  }
}