import 'package:fast_app_base/common/data/preference/item/nullable_preference_item.dart';
import 'package:fast_app_base/common/theme/custom_theme.dart';

class Prefs {
  static final appTheme = NullablePreferenceItem<CustomTheme>('appTheme');
  //로그인
  static final accessToken = NullablePreferenceItem<String>('accessToken');
  static final refreshToken = NullablePreferenceItem<String>('refreshToken');
  static final userEmail = NullablePreferenceItem<String>('userEmail');
  static final userName = NullablePreferenceItem<String>('userName');
  static final userPhotoURL = NullablePreferenceItem<String>('userPhotoURL');
}
