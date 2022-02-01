import 'package:flutter/material.dart';
import 'package:platformc/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Preserve extends StatefulWidget {
  const Preserve({Key? key}) : super(key: key);
  @override
  _PreserveState createState() => _PreserveState();
}
class _PreserveState extends State<Preserve> {
  final String screenName = '教室予約';
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:Header(headerTitle: screenName),
        body: Container()

    );
  }
}