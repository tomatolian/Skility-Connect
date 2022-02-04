import 'package:flutter/material.dart';
import 'package:platformc/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math';
class Preserve extends StatefulWidget {
  const Preserve({Key? key}) : super(key: key);

  @override
  _PreserveState createState() => _PreserveState();
}

class _PreserveState extends State<Preserve> {
  final String screenName = '教室予約';
  final _firestore = FirebaseFirestore.instance;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(headerTitle: screenName),
        body: Column(children: [
          TableCalendar(
            firstDay: DateTime.utc(_focusedDay.year, _focusedDay.month, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            //以下、追記部分。
            // フォーマット変更のボタン押下時の処理
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            selectedDayPredicate: (day) {      //以下追記部分
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
          ),
          Expanded(child: Container(
            child:SingleChildScrollView(child:Column(children: [
              for (var i = 0; i < Random().nextInt(5)+1; i++)
                TextButton(
                    onPressed: (){},
                    child:Text((Random().nextInt(5)+1).toString()+(Random().nextInt(3)+1).toString()+(Random().nextInt(3)+1).toString())),
            ],),
          ))
          ),
          ElevatedButton(onPressed: (){}, child: Text('予約')),
          Padding(padding: EdgeInsets.all(20))
        ],)
    );
  }
}
