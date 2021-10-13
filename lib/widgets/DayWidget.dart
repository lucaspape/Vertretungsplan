import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayWidget extends StatefulWidget {
  final String date;
  final bool dateIsCurrent;

  DayWidget({required this.date, required this.dateIsCurrent});

  @override
  State<StatefulWidget> createState() {
    return _DayWidgetState(date: date, dateIsCurrent: dateIsCurrent);
  }
}

class _DayWidgetState extends State<DayWidget> {
  final String date;
  final bool dateIsCurrent;

  _DayWidgetState({required this.date, required this.dateIsCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0),
      child: Card(
        child: ListTile(
          title: (() {
            if (dateIsCurrent) {
              return Text(
                date,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              );
            } else {
              return Text(
                date,
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            }
          }()),
        ),
      ),
    );
  }
}
