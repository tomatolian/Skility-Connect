import 'package:flutter/material.dart';
import 'package:platformc/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class PointSystem extends StatefulWidget {
  const PointSystem({Key? key}) : super(key: key);
  @override
  _PointSystemState createState() => _PointSystemState();
}
class _PointSystemState extends State<PointSystem> {
  final String screenName = 'ポイント付与';
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:Header(headerTitle: screenName),
      body: Container()
    );
  }
}