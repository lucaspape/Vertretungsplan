import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:vertretungsplan/util/Util.dart';

class HtmlListTile extends StatelessWidget {
  final String title;

  HtmlListTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0),
      child: Card(
        child: ListTile(
          title: Html(data: convertChars(title)),
        ),
      ),
    );
  }
}
