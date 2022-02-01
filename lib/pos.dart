import 'package:flutter/material.dart';
import 'package:platformc/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Pos extends StatefulWidget {
  @override
  _PosState createState() => _PosState();
}

class _PosState extends State<Pos> {
  final String screenName = '投稿画面';
  final _firestore = FirebaseFirestore.instance;
  var postername = '';
  var iconpass = '';
  var postController = TextEditingController();
  var tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      postername = snapshot.get('name');
      iconpass = snapshot.get('icon');
    });
    return Scaffold(
        appBar: Header(headerTitle: screenName),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              child: TextField(
                controller: postController,
                enabled: true,
                maxLength: 200,
                style: TextStyle(color: Colors.grey),
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              padding: EdgeInsets.all(20),
            ),
            Text('タグ (複数入力の場合は,区切り手入力してください)'),
            Padding(
              child: TextField(
                controller: tagController,
                enabled: true,
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              padding: EdgeInsets.all(20),
            ),
            TextButton(
              onPressed: () {
                var tags = tagController.text.split(',');
                var date = DateTime.now();
                print(date);
                _firestore.collection('posts').add({
                  'name': postername,
                  'post': postController.text,
                  'vote': 0,
                  'icon': iconpass,
                  'date': date.toString(),
                  'createAt': date,
                  'moyar': [],
                  'poster': FirebaseAuth.instance.currentUser!.uid,
                  'tags': tags
                });
                Navigator.of(context).pop();
              },
              child: Text('投稿'),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        )));
  }
}
