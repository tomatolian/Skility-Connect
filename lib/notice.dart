import 'package:flutter/material.dart';
import 'package:platformc/header.dart';

class Notice extends StatelessWidget {
  final String screenName = 'Notice';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: Center(child: Text(screenName)),
    );
  }
}