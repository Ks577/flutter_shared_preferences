import 'package:flutter/cupertino.dart';

Widget background() {
  return Container(
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://thrivewellbydesign.com/wp-content/uploads/2021/01/raul-varzar-L-CShKAuZsg-unsplash-683x1024.jpg'),
            fit: BoxFit.cover)),
  );
}
