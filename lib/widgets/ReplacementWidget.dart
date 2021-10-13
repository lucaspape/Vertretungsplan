import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vertretungsplan/constants/Strings.dart';
import 'package:vertretungsplan/util/Util.dart';

class ReplacementWidget extends StatelessWidget {
  final String comment;
  final String hour;
  final String room;

  ReplacementWidget(
      {required this.comment, required this.hour, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0),
      child: Card(
        child: ListTile(
          title: Text(convertChars(comment)),
          subtitle: Text(Strings.room + ': ' + convertChars(room)),
          leading: Text(convertChars(hour)),
        ),
      ),
    );
  }
}
