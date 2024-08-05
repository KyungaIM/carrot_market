import 'package:fast_app_base/screen/main/fab/w_floating_dangn_button.state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final floatingButtonStateProvider =
    StateNotifierProvider<FloatingButtonStateNotifier, FloatingButtonState>(
        (ref) => FloatingButtonStateNotifier(
              const FloatingButtonState(false,false),
            ));

class FloatingButtonStateNotifier extends StateNotifier<FloatingButtonState> {
  FloatingButtonStateNotifier(super.state);

  void onTapButton() {
    state = FloatingButtonState(!state.isExpanded, true);
  }

  void changeButtonSize(bool isSmall) {
    state = state.copyWith(isSmall: isSmall);
  }
}
