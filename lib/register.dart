import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:platformc/mainpage.dart';
import 'package:platformc/main.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String infoText = '';
  String email = '';
  String password = '';
  String name = '';
  String major = '';
  String grade = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '名前'),
                onChanged: (String value) {
                  setState(() {
                    name= value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '所属'),
                onChanged: (String value) {
                  setState(() {
                    major = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '学年'),
                onChanged: (String value) {
                  setState(() {
                    grade = value;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).set({
                        'name': name,
                        'major':major,
                        'grade': grade,
                        'icon': 'img/profile-icon.png',
                        'text':'Hello,Everyone!',
                        'points':0
                      });
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>Mainpage())
                      );
                    } catch (e) {
                      setState(() {
                        infoText = "登録に失敗しました：${e.toString()}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  child: const Text('ログインページへ'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>MyApp())
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
