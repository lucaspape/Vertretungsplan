import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vertretungsplan/api/Request.dart';
import 'package:vertretungsplan/constants/SettingStrings.dart';
import 'package:vertretungsplan/constants/Strings.dart';
import 'package:vertretungsplan/util/Settings.dart';
import 'package:vertretungsplan/widgets/SchoolClassWidget.dart';
import 'package:http/http.dart' as http;

class ClassListPage extends StatefulWidget {
  final Function(String password) switchToReplacementsPage;

  ClassListPage({required this.switchToReplacementsPage});

  @override
  State<StatefulWidget> createState() {
    _ClassListPageState _homeState =
        _ClassListPageState(switchToReplacementsPage: switchToReplacementsPage);
    return _homeState;
  }
}

class _ClassListPageState extends State<ClassListPage> {
  List<Widget> listWidgets = [];
  List<SchoolClassWidget> schoolClassWidgets = [];

  final Function(String password) switchToReplacementsPage;

  _ClassListPageState({required this.switchToReplacementsPage});

  bool buttonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(Strings.classSelection),
        actions: <Widget>[
          TextButton(
            onPressed: buttonDisabled ? null : onNextButton,
            child: Text(Strings.next),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: listWidgets,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      Settings settings = Settings();

      if (await settings.getString(SettingStrings.passwordSetting) != null &&
          await settings.getString(SettingStrings.passwordSetting) != '') {
        getClasses(await settings.getString(SettingStrings.passwordSetting));
      } else {
        showPasswordPrompt();
      }
    });
  }

  void showPasswordPrompt() async {
    final passwordInputController = TextEditingController();
    final passwordInputKey = GlobalKey<FormState>();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Strings.password),
            content: SingleChildScrollView(
              child: Form(
                key: passwordInputKey,
                child: TextFormField(
                  obscureText: true,
                  controller: passwordInputController,
                  decoration: InputDecoration(hintText: Strings.password),
                  validator: (String? value) {
                    if (value != null && value.trim().isEmpty) {
                      return Strings.passwordRequired;
                    }
                    return null;
                  },
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (passwordInputKey.currentState!.validate()) {
                    Settings().setString(SettingStrings.passwordSetting,
                        passwordInputController.text);

                    Navigator.of(context).pop();

                    getClasses(passwordInputController.text);
                  }
                },
                child: Text(Strings.ok),
              )
            ],
          );
        });
  }

  Map<String, bool> selectedClasses = {};

  void getClasses(String password) async {
    schoolClassWidgets = [];
    List<String>? classes = await Request.fetchClasses(http.Client(), password);

    if (classes == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(Strings.couldNotLoadDataWrongPassword),
      ));

      showPasswordPrompt();

      return;
    }

    for (String schoolClass in classes) {
      SchoolClassWidget schoolClassWidget = SchoolClassWidget(
        className: schoolClass,
        setClassSelected: (value) {
          selectedClasses[schoolClass] = value;

          bool atLeastOneClass = false;

          for (String className in selectedClasses.keys) {
            if (selectedClasses[className] == true) {
              atLeastOneClass = true;
            }
          }

          setState(() {
            buttonDisabled = !atLeastOneClass;
          });
        },
      );

      schoolClassWidgets.add(schoolClassWidget);
      listWidgets.add(schoolClassWidget);
    }

    setState(() {});
  }

  void onNextButton() async {
    Settings settings = Settings();

    if (await settings.getString(SettingStrings.passwordSetting) != null &&
        await settings.getString(SettingStrings.passwordSetting) != '') {
      String password =
          await settings.getString(SettingStrings.passwordSetting);

      List<String> enabledSchoolClasses = [];

      for (String schoolClass in selectedClasses.keys) {
        if (selectedClasses[schoolClass] != null) {
          enabledSchoolClasses.add(schoolClass);
        }
      }

      if (enabledSchoolClasses.length > 0) {
        Settings settings = Settings();
        settings.setString(
            SettingStrings.classListSetting, jsonEncode(enabledSchoolClasses));
        switchToReplacementsPage(password);
      }
    } else {
      showPasswordPrompt();
    }
  }
}
