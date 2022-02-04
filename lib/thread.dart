import 'package:flutter/material.dart';
import 'package:platformc/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platformc/pointsystem.dart';
import 'package:platformc/preservation.dart';
class thread extends StatefulWidget {
  thread({Key? key, required this.fire_documents, required this.index})
      : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> fire_documents;
  final int index;

  @override
  _threadState createState() => _threadState();
}

final postController = TextEditingController();

class _threadState extends State<thread> {
  final _firestore = FirebaseFirestore.instance;
  var postername = '';
  var iconpass = '';

  @override
  Widget build(BuildContext context) {
    print(widget.fire_documents[widget.index].id);
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      postername = snapshot.get('name');
      iconpass = snapshot.get('icon');
      print(iconpass);
    });
    return Scaffold(
        appBar: Header(
            headerTitle:
                widget.fire_documents[widget.index]['post'].toString()),
        body: Column(children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('posts')
                    .doc(widget.fire_documents[widget.index].id)
                    .collection('reply')
                    .orderBy('createAt')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  var fire_documents1 = snapshot.data!.docs;
                  return Column(children: [
                    Container(
                        color: Colors.white,
                        child: Padding(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    child: Image.asset(widget
                                        .fire_documents[widget.index]['icon']),
                                    width: 40,
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Text(
                                    widget.fire_documents[widget.index]['name'],
                                    style: TextStyle(fontSize: 15.0),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Text(widget.fire_documents[widget.index]['post'],
                                  style: TextStyle(fontSize: 16.0)),
                              Align(
                                child: Text(
                                  widget.fire_documents[widget.index]['date']
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                                alignment: Alignment.centerLeft,
                              )
                            ],
                          ),
                          padding: EdgeInsets.all(20),
                        )),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: fire_documents1.length,
                          itemBuilder: (context, index) {
                            debugPrint(fire_documents1[index]['name']);
                            return Card(
                                child: Padding(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        child: Image.asset(
                                            fire_documents1[index]['icon']),
                                        width: 40,
                                      ),
                                      Padding(padding: EdgeInsets.all(5)),
                                      Text(
                                        fire_documents1[index]['name'],
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Text(fire_documents1[index]['post'],
                                      style: TextStyle(fontSize: 16.0)),
                                  Align(
                                    child: Text(
                                      fire_documents1[index]['date'].toString(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  )
                                ],
                              ),
                              padding: EdgeInsets.all(20),
                            ));
                          }),
                    ),
                  ]);
                }),
          ),
          Row(children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(3),
                child: TextField(
                  autofocus: true,
                  style: new TextStyle(
                    fontSize: 10.0,
                    color: Colors.black,
                  ),
                  controller: postController,
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: '返信する',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    var date = DateTime.now();
                    _firestore
                        .collection('posts')
                        .doc(widget.fire_documents[widget.index].id)
                        .collection('reply')
                        .add({
                      'name': postername,
                      'post': postController.text,
                      'vote': 0,
                      'icon': iconpass,
                      'date': date.toString(),
                      'createAt': date,
                      'poster':FirebaseAuth.instance.currentUser!.uid
                    });
                  },
                  child: Text('送信'),
                ),
              ),
            ),
          ])
        ]),
        floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 70),
            child: Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end
                ,children: [
              FloatingActionButton.extended(
                  heroTag: 'hero1',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PointSystem(wid:widget.fire_documents[widget.index].id,moya:widget.fire_documents[widget.index]['vote'])));

                },
                tooltip: 'Increment',
                icon: Icon(Icons.thumb_up_alt_outlined),
                label: Text('解決')
              ),
              Padding(padding: EdgeInsets.all(4)),
              FloatingActionButton.extended(
                heroTag: 'hero2',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Preserve()));
                },
                tooltip: 'Increment',
                icon: Icon(Icons.fmd_good_outlined),
                label:Text('教室予約'),
              ),
            ])));
  }
}
