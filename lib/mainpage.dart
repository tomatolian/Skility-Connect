import 'package:flutter/material.dart';
import 'footer.dart';

class Mainpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'geikoapp2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
          bottom: false,
          child:Scaffold(
              bottomNavigationBar: Footer()
          )
      ),
    );
  }
}