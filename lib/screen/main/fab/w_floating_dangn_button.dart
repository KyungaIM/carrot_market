import 'package:fast_app_base/common/cli_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingDangnButton extends ConsumerWidget {
  final isExpanded = true;
  const FloatingDangnButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: [
      AnimatedContainer(duration: 300.ms,color: isExpanded? Colors.black.withOpacity(0.4):Colors.transparent),

    ],);
  }
}
