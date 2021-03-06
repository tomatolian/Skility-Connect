import 'package:flutter/material.dart';
import 'package:platformc/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platformc/mainpage.dart';
class PointSystem extends StatefulWidget {
  const PointSystem({Key? key,required this.wid,required this.moya}) : super(key: key);
  final moya;
  final wid;
  @override
  _PointSystemState createState() => _PointSystemState();
}
class _PointSystemState extends State<PointSystem> {
  final String screenName = 'ポイント付与';
  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> documentList = [];
  Map replylistmap={};
  List replylist=<String>[];
  List replylistuid=<String>[];
  List rptf=<bool>[];
  var t='';
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('posts').doc(widget.wid).collection('reply')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      documentList = snapshot.docs;
      documentList
          .where((element) => replylistmap.containsKey(element['poster'])==false && element['poster']!=FirebaseAuth.instance.currentUser!.uid)
          .forEach((element) {
            setState(() {
              replylistmap[element['poster']]=element['name'];
            });
      });
      setState(() {
        replylist=replylistmap.values.toList();
        replylistuid=replylistmap.keys.toList();
        for (var i = 0; i < 10; i++) {
          rptf.add(false);
        }
      });
      print(rptf);
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:Header(headerTitle: screenName),
      body:Column(children: [
        Padding(child:Text('解決に貢献してくれた人を選択してください'),padding: EdgeInsets.all(20),),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child:
              Card(
                color: (rptf[index])? Colors.white24:Colors.white,
                child: Padding(
                  child: Text(replylist[index]),
                  padding: EdgeInsets.all(6.0),
                ),
              ),
              onTap: (){
                setState(() {
                  if (rptf[index]){
                    rptf[index]=false;
                  }
                  else{
                    rptf[index]=true;
                  }
                });
              },
            );
          },
          itemCount: replylist.length,
        ),
        ElevatedButton(
          child: Text('解決'),
          onPressed: (){
          if (rptf.indexOf(true)==-1){
            setState(() {
              t='選択してください';
            });
          }else{
            var uid =replylistuid[rptf.indexOf(true)];
            FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .update({
              'points': FieldValue.increment(100+10*widget.moya),
            });
            FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.wid)
                .update({
              'stat': true,
            });
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => Mainpage()),
                    (_) => false);
          }
        },
            ),
        Text(t,style: TextStyle(color: Colors.red),),
      ],
      )
    );
  }
}