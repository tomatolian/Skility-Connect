import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget with PreferredSizeWidget {
  final String headerTitle;

  Header({this.headerTitle = 'Home'});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Container(child: Text(headerTitle, style: const TextStyle())),
    );
  }
}
