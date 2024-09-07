import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

enum RoundButtonTheme {
  white(AppColors.brightGrey, Colors.black, AppColors.brightGrey, backgroundColorProvider: orangeColorProvider),
  whiteWithGreyBorder(Colors.transparent, Colors.grey, Colors.grey,
      backgroundColorProvider: orangeColorProvider),
  blink(AppColors.blue, Colors.white, Colors.black, backgroundColorProvider: orangeColorProvider);

  const RoundButtonTheme(
    this.bgColor,
    this.textColor,
    this.borderColor, {
    this.backgroundColorProvider,
  }) : shadowColor = Colors.transparent;

  ///RoundButtonTheme 안에서 Custome Theme 분기가 필요하다면 이렇게 함수로 사용
  final Color Function(BuildContext context)? backgroundColorProvider;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final Color shadowColor;
}

Color orangeColorProvider(BuildContext context) => context.appColors.orangeButtonBackground;

Color Function(BuildContext context) defaultColorProvider(Color color) => orangeColorProvider;
