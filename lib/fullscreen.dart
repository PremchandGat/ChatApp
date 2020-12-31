import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  final String imgurl;
  FullScreen({Key key, this.imgurl}) : super(key: key);
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Image(image: NetworkImage(imgurl)),
    );
  }
}
