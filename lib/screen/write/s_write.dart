import 'dart:io';
import 'dart:math';

import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/widget/round_button_theme.dart';
import 'package:fast_app_base/common/widget/w_round_button.dart';
import 'package:fast_app_base/entity/post/vo_simple_product_post.dart';
import 'package:fast_app_base/entity/product/product_status.dart';
import 'package:fast_app_base/screen/dialog/d_message.dart';
import 'package:fast_app_base/screen/post_detail/s_post_detail.dart';
import 'package:fast_app_base/screen/write/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/util/app_keyboard_util.dart';
import '../../entity/dummies.dart';
import '../../entity/product/vo_product.dart';
import '../../entity/user/vo_address.dart';
import 'd_select_image_source.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen>
    with KeyboardDetector {
  final List<String> imageList = [];
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    titleController.addListener(() {
      setState(() {});
    });
    priceController.addListener(() {
      setState(() {});
    });
    descriptionController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: '내 물건 팔기'.text.bold.make(),
        actions: [
          Tap(
            onTap: () {},
            child: '임시저장'.text.make().p(15),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageSelectWidget(
              imageList,
              onTap: () async {
               try {
                  final selectedSource = await SelectImageSourceDialog().show();
                  if (selectedSource == null) {
                    return;
                  }
                  final file =
                      await ImagePicker().pickImage(source: selectedSource);
                  if (file == null) {
                    return;
                  }
                  setState(() {
                    imageList.add(file.path);
                  });
                } on PlatformException catch(e){
                 switch(e.code){
                   case 'invalid_image':
                     MessageDialog('지원하지 않는 이미지 형식입니다').show();
                 }
               }
              },
              onTapDeleteImage: (imagePath){
                setState(() {
                  imageList.remove(imagePath);
                });
              },
            ),
            height10,
            _TitleEditor(titleController),
            height30,
            _PriceEditor(controller: priceController),
            height30,
            _DescEditor(descriptionController),
          ],
        ).pSymmetric(h: 15),
      ),
      bottomSheet: isKeyboardOn
          ? null
          : RoundButton(
              text: isLoading ? '저장중' : '작성완료',
              isFullWidth: true,
              borderRadius: 6,
              rightWidget: isLoading
                  ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator())
                      .pOnly(right: 80)
                  : null,
              onTap: () {
                final title = titleController.text;
                final price = int.parse(priceController.text);
                final desc = descriptionController.text;
                setState(() {
                  isLoading = true;
                });
                final list = ref.read(postProvider);
                final simpleProductPost = SimpleProductPost(
                    6,
                    user3,
                    Product(
                        user3, title, price, ProductStatus.normal, imageList),
                    title,
                    const Address('서울특별시주소', '플러터동'),
                    0,
                    0,
                    DateTime.now());
                ref.read(postProvider.notifier).state = List.of(list)
                  ..add(simpleProductPost);
                Nav.pop(context);
                Nav.push(PostDetailScreen(
                  simpleProductPost.id,
                  simpleProductPost: simpleProductPost,
                ));
              },
              isEnabled: isValid,
            ),
    );
  }

  bool get isValid =>
      isNotEmpty(titleController.text) &&
      isNotEmpty(priceController.text) &&
      isNotEmpty(descriptionController.text);
}

class _ImageSelectWidget extends StatelessWidget {
  final List<String> imageList;
  final VoidCallback onTap;
  final void Function(String path) onTapDeleteImage;

  const _ImageSelectWidget(this.imageList, {super.key, required this.onTap, required this.onTapDeleteImage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SelectImageButton(onTap: onTap, imageList: imageList).pOnly(top: 10,right: 7),
              ...imageList.map((imagePath) => Stack(
                children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.fill,
                          ).box.rounded.make()),
                    ).pOnly(left: 4, right: 10, top: 10),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Tap(
                        onTap: (){
                          onTapDeleteImage(imagePath);
                        },
                        child: Transform.rotate(
                          angle: pi/4,
                          child:const Icon(Icons.add_circle),
                        ).pOnly(left: 30, bottom: 30),
                      ),
                    ),
                  )
                  ]
              ))
            ],
          )),
    );
  }
}

class SelectImageButton extends StatelessWidget {
  const SelectImageButton({
    super.key,
    required this.onTap,
    required this.imageList,
  });

  final VoidCallback onTap;
  final List<String> imageList;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt),
            RichText(
                text: TextSpan(children: [
              TextSpan(text: imageList.length.toString()),
              const TextSpan(text: '/10')
            ]))
          ],
        ).box.rounded.border(color: Colors.grey).make(),
      ),
    );
  }
}

class _TitleEditor extends StatelessWidget {
  final TextEditingController controller;

  _TitleEditor(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '제목'.text.bold.make(),
        height5,
        TextField(
          controller: controller,
          decoration: const InputDecoration(
              hintText: '제목',
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.orange,
              )),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey,
              ))),
        )
      ],
    );
  }
}

class _PriceEditor extends StatefulWidget {
  final TextEditingController controller;

  const _PriceEditor({super.key, required this.controller});

  @override
  State<_PriceEditor> createState() => _PriceEditorState();
}

class _PriceEditorState extends State<_PriceEditor> {
  bool isDonateMode = false;
  final priceNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '거래방식'.text.bold.make(),
        height10,
        Row(
          children: [
            RoundButton(
                theme: isDonateMode
                    ? RoundButtonTheme.whiteWithGreyBorder
                    : RoundButtonTheme.white,
                text: '판매하기',
                onTap: () {
                  setState(() {
                    widget.controller.clear();
                    isDonateMode = false;
                  });
                  delay(() {
                    AppKeyboardUtil.show(context, priceNode);
                  });
                }),
            width5,
            RoundButton(
                theme: !isDonateMode
                    ? RoundButtonTheme.whiteWithGreyBorder
                    : RoundButtonTheme.white,
                text: '나눔하기',
                onTap: () {
                  widget.controller.text = "0";
                  setState(() {
                    isDonateMode = true;
                  });
                })
          ],
        ),
        height10,
        TextField(
          focusNode: priceNode,
          controller: widget.controller,
          enabled: !isDonateMode,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              hintText: '￦ 가격을 입력해 주세요',
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.orange,
              )),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey,
              ))),
        )
      ],
    );
  }
}

class _DescEditor extends StatelessWidget {
  final TextEditingController controller;

  _DescEditor(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '자세한 설명'.text.bold.make(),
        height5,
        TextField(
          controller: controller,
          maxLines: 7,
          decoration: const InputDecoration(
              hintText: '에 올릴 게시글 내용을 작성해 주세요'
                  '신뢰할 수 있는 거래를 위해 자세히 적어주세요',
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.orange,
              )),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey,
              ))),
        )
      ],
    );
  }
}
