import 'package:flutter/cupertino.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_dangn_button.riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalLifeFragment  extends ConsumerStatefulWidget{
  const LocalLifeFragment({super.key});

  @override
  ConsumerState createState() => _LocalLifeFragmentState();
}

class _LocalLifeFragmentState extends ConsumerState<LocalLifeFragment> {
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener((){
      final floatingButtonState = ref.watch(floatingButtonStateProvider);
      final isSmall = floatingButtonState.isSmall;
      if (scrollController.position.pixels > 100 && !isSmall){
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(true);
      } else if(scrollController.position.pixels < 100 && isSmall){
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      children: [
        Image.network('https://picsum.photos/id/658/411/411', fit: BoxFit.fill ),
        Container(height: 500, color: Colors.orange,),
        Container(height: 500, color: Colors.orange,),
        Container(height: 500, color: Colors.orange,),
        Container(height: 500, color: Colors.orange,),
      ],
    );
  }
}
