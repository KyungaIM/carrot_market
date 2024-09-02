import 'package:freezed_annotation/freezed_annotation.dart';
part 'vo_user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required final int id,
    required final String nickname,
    required final double temperature,
    required final String profileUrl,
  }) = _User;
}