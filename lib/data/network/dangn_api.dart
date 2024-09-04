import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/data/network/result/api_error.dart';
import 'package:fast_app_base/screen/notification/vo/notification_dummies.dart';
import 'package:fast_app_base/screen/notification/vo/vo_notification.dart';
import '../../common/data/preference/prefs.dart';
import '../../common/util/auth/auth_util.dart';
import '../simple_result.dart';

/// http 메소드
enum _HttpMethod { get, post, postForm }

/// 베이스 URL
const baseUrl = 'http://.../daangn';

const firebaseVerifyV1 = '/firebaseVerify';
const logoutLogSaveV1 = '/logoutLogSaveV1';
const memberSaveV1 = '/memberSaveV1';
const memberCheckV1 = '/memberCheckV1';

/// 베이스 옵션
final baseOptions = BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
);

/// 연결용 객체 생성
final dio = Dio(baseOptions);

class DaangnApi {
  static final _instance = DaangnApi._();

  DaangnApi._();

  static Future<dynamic> _call({
    required _HttpMethod httpMethod,
    required String url,
    dynamic data,
    bool useToken = true,
    bool isRetry = false,
  }) async {
    // 헤더 설정
    final headers = <String, dynamic>{};
    if (useToken) {
      final accessToken = Prefs.accessToken.get() ?? '';
      headers['access_token'] = accessToken;
    }
    Response<dynamic> response;
    // 요청
    try {
      if (httpMethod == _HttpMethod.get) {
        response = await dio.get(
          url,
          queryParameters: data,
          options: Options(headers: headers),
        );
      } else if (httpMethod == _HttpMethod.post) {
        headers[Headers.contentTypeHeader] = Headers.jsonContentType;
        response = await dio.post(
          url,
          data: data,
          options: Options(headers: headers),
        );
      } else {
        // postForm
        headers[Headers.contentTypeHeader] = Headers.formUrlEncodedContentType;
        response = await dio.post(
          url,
          data: data,
          options: Options(headers: headers),
        );
      }

      final bool ok = response.data['ok'];
      if (!ok) {
        throw HttpException(response.data['msg'] ?? 'daangn-api error.', uri: Uri.parse(url));
      }
      return response.data['info'] ?? response.data['list'];
    } on DioException catch (e) {
      if (!isRetry && e.response?.statusCode == 401) {
        await _jwtTokenRefresh();
        return await _call(
          httpMethod: httpMethod,
          url: url,
          data: data,
          useToken: useToken,
          isRetry: true,
        );
      }
      rethrow;
    }
  }

  static Future<SimpleResult<List<DaangnNotification>, ApiError>> getNotification() async {
    await sleepAsync(500.ms);
    return SimpleResult.success(notificationList);
  }

  /// 파이어베이스 인증
  static Future<void> firebaseVerify(String
  firebaseToken) async {
    final osType = Platform.isAndroid ? '1' : '2'; // 운영체제 유형 (1: 안드로이드, 2: iOS)
    final info = await _call(
      httpMethod: _HttpMethod.postForm,
      url: firebaseVerifyV1,
      data: {
        'firebase_token': firebaseToken,
        'os_type': osType,
      },
      useToken: false,
    );
    await Prefs.accessToken.set(info['access_token']);
    await Prefs.refreshToken.set(info['refresh_token']);
  }

  /// JWT 토큰 갱신
  static Future<void> _jwtTokenRefresh() async {
    try {
      final info = await _call(
        httpMethod: _HttpMethod.postForm,
        url: '',
        data: {'refresh_token': Prefs.accessToken.get() ?? ''},
      );
      await Prefs.accessToken.set(info['access_token']);
      await Prefs.refreshToken.set(info['refresh_token']);
    } catch (e) {
      await signOut();
      return;
    }
  }

  /// 회원가입
  static Future<void> memberSave(String firebaseToken) async {
    await _call(
      httpMethod: _HttpMethod.postForm,
      url: memberSaveV1,
      data: {
        'firebase_token': firebaseToken,
        'terms_agree_yn': 'N',
        'privacy_agree_yn': 'N',
        'push_agree_yn': 'N',
        'sms_agree_yn': 'N',
        'email_agree_yn': 'N',
      },
      useToken: false,
    );
  }

  /// 회원 여부 조회
  static Future<dynamic> memberCheck(String authEmail) async {
    return await _call(
      httpMethod: _HttpMethod.get,
      url: memberCheckV1,
      data: {'auth_email': authEmail},
      useToken: false,
    );
  }

  /// 로그아웃 이력 저장
  static Future<void> logoutLogSave(String authEmail, String osType) async {
    await _call(
      httpMethod: _HttpMethod.postForm,
      url: logoutLogSaveV1,
      data: {
        'auth_email': authEmail,
        'os_type': osType,
      },
      useToken: false,
    );
  }

  factory DaangnApi() => _instance;
}