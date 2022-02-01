import 'package:flutter/material.dart';
import 'header.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String screenName = 'Profile';
  final _firestore = FirebaseFirestore.instance;
  var name = '';
  var intro = '';
  var grade = '';
  var major = '';
  var icon = 'img/profile-icon.png';
  List<DocumentSnapshot> documentList = [];
  var myposts = [];
  var mymoya = [];
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      documentList = snapshot.docs;
      documentList
          .where((element) => element['poster'] == uid)
          .forEach((element) {
        myposts.add(element['post']);
      });
      documentList
          .where((element) => element['moyar'].indexOf(uid) != -1)
          .forEach((element) {
        mymoya.add(element['post']);
        print(mymoya);
      });
    });
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
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
          leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileSetting(
                              name: name,
                              intro: intro,
                              major: major,
                              grade: grade,
                            )));
              },
            ),
          ),
          title: Container(child: Text('Profile', style: const TextStyle())),
        ),
        body: SingleChildScrollView(
            child: Center(
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
              Padding(padding: EdgeInsets.all(20)),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '自分の投稿',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    'モヤッとした投稿',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Padding(
                            child: Text(
                              '${myposts[index]}',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            padding: EdgeInsets.all(6.0),
                          ),
                        );
                      },
                      itemCount: myposts.length,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Padding(
                            child: Text(
                              '${mymoya[index]}',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            padding: EdgeInsets.all(6.0),
                          ),
                        );
                      },
                      itemCount: mymoya.length,
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                  child: const Text('ログアウト'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (_) => false);
                  })
            ],
          ),
        )));
  }
}

class ProfileSetting extends StatefulWidget {
  ProfileSetting(
      {Key? key,
      required this.name,
      required this.intro,
      required this.grade,
      required this.major});

  var name;
  var intro;
  var grade;
  var major;

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final String screenName = '設定';
  var nameController;
  var introController;
  var gradeController;
  var majorController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    introController = TextEditingController(text: widget.intro);
    gradeController = TextEditingController(text: widget.grade);
    majorController = TextEditingController(text: widget.major);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(headerTitle: screenName),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: '名前'),
                  controller: nameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '所属'),
                  controller: majorController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '学年'),
                  controller: gradeController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '紹介文'),
                  controller: introController,
                ),
                ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        'name': nameController.text,
                        'major': majorController.text,
                        'grade': gradeController.text,
                        'text': introController.text
                      });
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: Text('変更'))
              ],
            ),
          ),
        ));
  }
}
