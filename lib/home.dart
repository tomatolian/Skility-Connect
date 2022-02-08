import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:platformc/other_profile.dart';
import 'package:platformc/ranking.dart';
import 'package:platformc/pos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:platformc/thread.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platformc/tagsearch.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String screenName = 'Home';
  final _firestore = FirebaseFirestore.instance;
  bool moya = false;
  var moyaCount = 0;
  var date = '';
  var param = 'createAt';
  var params = ['新しい順', '古い順', 'モヤっと順'];
  bool swsort = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PopupMenuButton<String>(
              initialValue: '新しい順',
              icon: Icon(Icons.sort),
              onSelected: (String s) {
                setState(() {
                  if (s == '新しい順') {
                    param = 'createAt';
                    swsort = true;
                  } else if (s == 'モヤっと順') {
                    param = 'vote';
                    swsort = true;
                  } else {
                    param = 'createAt';
                    swsort = false;
                  }
                });
              },
              itemBuilder: (BuildContext context) {
                return params.map((String s) {
                  return PopupMenuItem(
                    child: Text(s),
                    value: s,
                  );
                }).toList();
              }),
        ),
        title: Container(child: Text('Home', style: const TextStyle())),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.military_tech_outlined),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Ranking()));
                },
              ))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('posts')
              .orderBy(param, descending: swsort)
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
            print(fire_documents[1]['tags'].length);
            return ListView.builder(
                shrinkWrap: true,
                itemCount: fire_documents.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => thread(
                                stat: fire_documents[index]['stat'],
                                index: index,
                                fire_documents: fire_documents,
                                  )));
                    },
                    child: Padding(
                    padding: EdgeInsets.all(4),
                      child:Card(
                      color: (fire_documents[index]['stat'])? Colors.green[100]:Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color:Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherProfile(
                                                      uid: fire_documents[index]
                                                          ['poster'])));
                                    },
                                    child: Image.asset(
                                        fire_documents[index]['icon'])),
                                width: 50,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                fire_documents[index]['name'],
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Text(fire_documents[index]['post'],
                              style: TextStyle(fontSize: 16.0)),
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index1) {
                                return Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(0),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TagSearch(
                                                      tag: fire_documents[index]
                                                          ['tags'][index1],
                                                    )));
                                      },
                                      child: Text('#' +
                                          fire_documents[index]['tags']
                                              [index1]),
                                    ));
                              },
                              itemCount: fire_documents[index]['tags'].length,
                            ),
                          ),
                          // (fire_documents[index]['tags'].isEmpty)? SizedBox.shrink(): Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: <Widget>[
                          //     fire_documents[index]['tags'].forEach((tag){
                          //       Text(tag);
                          //     })
                          //   ],),
                          Row(children: [
                            Expanded(
                              child: Text(
                                fire_documents[index]['date'].toString(),
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.reply,
                                    )),
                                moyaButton(
                                  index: index,
                                  fire_documents: fire_documents,
                                ),
                                Text(fire_documents[index]['vote'].toString()),
                                Padding(padding: EdgeInsets.only(left: 20)),
                              ],
                            ),
                          ]),
                        ],
                      ),
                      padding: EdgeInsets.only(top: 20,bottom: 10,left: 20,right: 20),
                    )),)
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Pos()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class moyaButton extends HookWidget {
  moyaButton({Key? key, required this.index, required this.fire_documents})
      : super(key: key);
  final index;
  final fire_documents;

  @override
  Widget build(BuildContext context) {
    final moya = useState<bool>(false);
    if (fire_documents[index]['moyar']
            .indexOf(FirebaseAuth.instance.currentUser!.uid) !=
        -1) {
      moya.value = true;
    } else {
      moya.value = false;
    }
    ;
    return IconButton(
      onPressed: () {
        (moya.value) ? moya.value = false : moya.value = true;
        togglemoya(moya.value, fire_documents, index);
      },
      icon: (moya.value)
          ? Icon(
              Icons.cloud,
              color: Colors.grey,
            )
          : Icon(
              Icons.cloud_outlined,
              color: Colors.grey,
            ),
    );
  }
}

void togglemoya(
    moya, List<QueryDocumentSnapshot<Object?>> fire_documents, index) {
  if (moya) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(fire_documents[index].id)
        .update({
      'vote': FieldValue.increment(1),
      'moyar': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  } else {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(fire_documents[index].id)
        .update({
      'vote': FieldValue.increment(-1),
      'moyar': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
    });
  }
}
