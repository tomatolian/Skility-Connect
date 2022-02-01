import 'package:flutter/material.dart';
import 'header.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtherProfile extends StatefulWidget {
  OtherProfile({Key? key,required this.uid});
  final String uid;
  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  final String screenName = 'OtherProfile';
  final _firestore = FirebaseFirestore.instance;
  var name = '';
  var intro = '';
  var grade = '';
  var major = '';
  var icon = 'img/OtherProfile-icon.png';
  List<DocumentSnapshot> documentList = [];
  var myposts=[];
  var mymoya=[];
  @override
  void initState() {
    super.initState();
    _firestore
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        name = snapshot.get('name');
        intro = snapshot.get('text');
        grade = snapshot.get('grade');
        major = snapshot.get('major');
        icon = snapshot.get('icon');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Container(child: Text(name, style: const TextStyle())),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              SizedBox(height: 100, width: 100, child: Image.asset(icon)),
              Text(name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              Text(major),
              Text(grade),
              Text(intro),
              ],),
          ),
        );
  }
}

