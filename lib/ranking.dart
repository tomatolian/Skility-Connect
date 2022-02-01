import 'package:flutter/material.dart';
import 'package:platformc/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  final String screenName = 'ランキング';
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .orderBy('points', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            var fire_documents = snapshot.data!.docs;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: fire_documents.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: Padding(
                    child: Row(
                      children: [
                        Padding(padding: EdgeInsets.all(10)),
                        Text((index + 1).toString() + '位',
                            style: TextStyle(fontSize: 40)),
                        Padding(padding: EdgeInsets.all(20)),
                        SizedBox(
                            width: 50,
                            child: Image.asset(fire_documents[index]['icon'])),
                        Padding(padding: EdgeInsets.all(10)),
                        Text(fire_documents[index]['name'],
                            style: TextStyle(fontSize: 20)),
                        Expanded(child:
                        Text(
                            fire_documents[index]['points'].toString() + ' pt',textAlign: TextAlign.right))
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                  ));
                });
          }),
    );
  }
}
