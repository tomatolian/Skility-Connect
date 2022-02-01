import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:platformc/ranking.dart';
import 'package:platformc/pos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:platformc/thread.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TagSearch extends StatefulWidget {
  TagSearch({Key? key,required this.tag});
   final tag;
  @override
  _TagSearchState createState() => _TagSearchState();
}

class _TagSearchState extends State<TagSearch> {
  final String screenName = 'TagSearch';
  final _firestore = FirebaseFirestore.instance;
  bool moya = false;
  var moyaCount = 0;
  var date = '';
  var param = 'createAt';
  var params = ['新しい順', 'モヤっと順'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(child: Text(widget.tag, style: const TextStyle())),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('posts').where('tags', arrayContains: widget.tag)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            var fire_documents = snapshot.data!.docs;
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
                                index: index,
                                fire_documents: fire_documents,
                              )));
                    },
                    child: Card(
                        child: Padding(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    child:
                                    Image.asset(fire_documents[index]['icon']),
                                    width: 40,
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Text(
                                    fire_documents[index]['name'],
                                    style: const TextStyle(fontSize: 15.0),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Text(fire_documents[index]['post'],
                                  style: const TextStyle(fontSize: 16.0)),
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index1) {
                                    return Padding(
                                        padding:const EdgeInsets.all(8),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding:const EdgeInsets.all(0),
                                          ),
                                          onPressed: () {},
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.reply,
                                      )),
                                  moyaButton(
                                    index: index,
                                    fire_documents: fire_documents,
                                  ),
                                  Text(fire_documents[index]['vote'].toString()),
                                  const Padding(padding: EdgeInsets.only(left: 20)),
                                ],
                              ),
                              Align(
                                child: Text(
                                  fire_documents[index]['date'].toString(),
                                  style:
                                  const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                                alignment: Alignment.centerLeft,
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                        )),
                  );
                });
          }),
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
