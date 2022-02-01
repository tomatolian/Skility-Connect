import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platformc/ranking.dart';
import 'package:platformc/home.dart';
class Header_home extends StatelessWidget with PreferredSizeWidget{
  final String email;
  Header_home({required this.email});
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon:const Icon(Icons.sort),
            onPressed: () {
              // Home(email: email,sortparam:'vote');
            },
          )
      ),
      title:Container(
          child:  const Text(
              'Home',
              style:TextStyle(
              )
          )
      ),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
          child: IconButton(
          icon:const Icon(Icons.military_tech_outlined),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>const Ranking())
            );},
          )
        )
      ],
    );
  }
}
