import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_dangn_button.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_dangn_button.riverpod.dart';
import 'package:fast_app_base/screen/main/tab/home/w_product_post_item.dart';
import 'package:fast_app_base/screen/notification/s_notification.dart';
import 'package:fast_app_base/screen/write/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFragment extends ConsumerStatefulWidget {
  const HomeFragment({super.key});

  @override
  ConsumerState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends ConsumerState<HomeFragment> {
  final scrollController = ScrollController();
  String title = '플러터동';

  @override
  void initState() {
    scrollController.addListener(() {
      final floatingButtonState = ref.watch(floatingButtonStateProvider);
      final isSmall = floatingButtonState.isSmall;
      if (scrollController.position.pixels > 100 && !isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(true);
      } else if (scrollController.position.pixels < 100 && isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postList = ref.watch(postProvider);
    return Column(
      children: [
        AppBar(
          title: PopupMenuButton<String>(
            onSelected: (value){
              setState(() {
                title = value;
              });
            },
            itemBuilder: (BuildContext context) =>
                ["다트동", "앱동"].map((e) => PopupMenuItem(
                      value: e,
                      child: Text(e),
                    )).toList(),
            child: Text(title),
          ),
          actions: [
            IconButton(onPressed: (){
              Nav.push(NotificationScreen());
            }, icon: const Icon(Icons.notifications_none))
          ],
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: FloatingDangnButton.height),
            controller: scrollController,
            itemBuilder: (context, index) => ProductPostItem(postList[index]),
            itemCount: postList.length,
            separatorBuilder: (context, index) =>
                const Line().pSymmetric(h: 15),
          ),
        ),
      ],
    );
  }
}
