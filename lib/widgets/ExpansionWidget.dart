import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vertretungsplan/util/Settings.dart';
import 'package:vertretungsplan/util/Util.dart';
import 'package:vertretungsplan/widgets/CustomExpansionTile.dart' as custom;

class ExpansionWidget extends StatefulWidget {
  final String title;
  final bool expanded;
  final List<Widget> replacements;

  ExpansionWidget(
      {required this.title,
      required this.expanded,
      required this.replacements});

  @override
  State<StatefulWidget> createState() {
    return (_ExpansionWidgetState(
        title: title, expanded: expanded, replacements: replacements));
  }
}

class _ExpansionWidgetState extends State<ExpansionWidget> {
  final String title;
  bool expanded;
  bool darkTheme =
      SchedulerBinding.instance?.window.platformBrightness == Brightness.light;
  final List<Widget> replacements;

  _ExpansionWidgetState(
      {required this.title,
      required this.expanded,
      required this.replacements});

  //this timer checks every second if the user changed the device theme, otherwise stuff will look shit
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer?.cancel();

    timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          darkTheme = SchedulerBinding.instance?.window.platformBrightness ==
              Brightness.light;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return custom.ExpansionTile(
      iconColor:
          expanded ? Colors.green : (darkTheme ? Colors.black : Colors.white),
      initiallyExpanded: expanded,
      onExpansionChanged: (state) {
        Settings().setString(title + '_expanded', state.toString());

        setState(() {
          expanded = state;
        });
      },
      title: Text(
        convertChars(title),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: darkTheme
                ? (expanded ? Colors.green : Colors.black)
                : (expanded ? Colors.green : Colors.white)),
      ),
      children: replacements,
    );
  }
}
