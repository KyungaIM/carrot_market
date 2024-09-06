import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/entity/post/vo_simple_product_post.dart';
import 'package:fast_app_base/entity/product/product_status.dart';
import 'package:fast_app_base/entity/user/vo_address.dart';
import 'package:fast_app_base/entity/user/vo_user.dart';

import 'product/vo_product.dart';

String picSum(int id) {
  return 'https://picsum.photos/id/$id/200/200';
}

final user1 = User(
  id: 1,
  nickname: "홍길동",
  temperature: 36.5,
  profileUrl: picSum(1010),
);

final user2 = User(
  id: 2,
  nickname: "바다",
  temperature: 36.5,
  profileUrl: picSum(900),
);

final user3 = User(
  id: 3,
  nickname: "파도",
  temperature: 36.5,
  profileUrl: picSum(700),
);

final product1 = Product(
    user1,
    '아이폰13',
    700000,
    ProductStatus.normal,
    [picSum(500), picSum(501), picSum(502), picSum(503)]);

final product2 = Product(
    user2,
    '키링',
    3000,
    ProductStatus.normal,
    [picSum(400), picSum(501), picSum(502), picSum(503)]);

final product3 = Product(
    user3,
    '스마트티비',
    30000,
    ProductStatus.normal,
    [picSum(300), picSum(501), picSum(502), picSum(503)]);

final post1 = SimpleProductPost(1,product1.user, product1, '글의 내용입니다', const Address('서울특별시주소','플러터동'), 3, 2, DateTime.now().subtract(30.minutes));
final post2 = SimpleProductPost(2,product2.user, product1, '글의 내용입니다', const Address('서울특별시주소','앱동'), 3, 2, DateTime.now().subtract(5.minutes));
final post3 = SimpleProductPost(3,product3.user, product1, '글의 내용입니다', const Address('서울특별시주소','다트동'), 30, 120,  DateTime.now().subtract(10.seconds));

final postList = [post1,post2,post3,post1,post2,post3];
