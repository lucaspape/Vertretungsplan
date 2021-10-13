import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SchoolClassWidget extends StatefulWidget {
  final String className;
  final Function(bool) setClassSelected;

  SchoolClassWidget({required this.className, required this.setClassSelected});

  @override
  State<StatefulWidget> createState() {
    return _SchoolClassWidgetState(
        className: className, setClassSelected: setClassSelected);
  }
}

class _SchoolClassWidgetState extends State<SchoolClassWidget> {
  final String className;
  bool classSelected = false;

  final Function(bool) setClassSelected;

  _SchoolClassWidgetState(
      {required this.className, required this.setClassSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (classSelected) {
            setState(() {
              classSelected = false;
              setClassSelected(false);
            });
          } else {
            setState(() {
              classSelected = true;
              setClassSelected(true);
            });
          }
        },
        child: ListTile(
          title: Text(className),
          trailing: Checkbox(
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  classSelected = value;
                  setClassSelected(value);
                }
              });
            },
            value: classSelected,
          ),
        ),
      ),
    );
  }
}
