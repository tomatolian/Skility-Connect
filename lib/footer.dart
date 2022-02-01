import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'notice.dart';

class Footer extends StatefulWidget {
  @override
  _Footer createState() =>_Footer();
}
class _Footer extends State<Footer> {
  int _selectedindex =0;
  final _bottomNavigationBarItem =<BottomNavigationBarItem>[];
  final List _footerItemOrder = [
    'Home',
    'profile',
    'notification',
  ];

  void _onItemTapped(int index) {
    setState( () {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final temp = [
      Home(),
      Profile(),
      Notice()
    ];

    return Scaffold(
      body : temp[_selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people),label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none),label: 'Notification'),
        ],
        currentIndex: _selectedindex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black45,
      ),
    );
  }
}