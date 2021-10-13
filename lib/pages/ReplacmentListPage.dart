import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vertretungsplan/api/Request.dart';
import 'package:vertretungsplan/constants/SettingStrings.dart';
import 'package:vertretungsplan/constants/Strings.dart';
import 'package:vertretungsplan/util/Settings.dart';
import 'package:vertretungsplan/widgets/DayWidget.dart';
import 'package:vertretungsplan/widgets/ReplacementWidget.dart';
import 'package:vertretungsplan/widgets/ExpansionWidget.dart';
import 'package:vertretungsplan/widgets/HtmlListTile.dart';
import 'package:http/http.dart' as http;

class ReplacementListPage extends StatefulWidget {
  final String password;
  final Function returnToClassSelectionCallback;

  ReplacementListPage(
      {required this.password, required this.returnToClassSelectionCallback});

  @override
  State<StatefulWidget> createState() {
    return _ReplacementListPageState(
        password: password,
        returnToClassSelectionCallback: returnToClassSelectionCallback);
  }
}

class _ReplacementListPageState extends State<ReplacementListPage> {
  final String password;
  final Function returnToClassSelectionCallback;

  List<Widget> listWidgets = [];

  _ReplacementListPageState(
      {required this.password, required this.returnToClassSelectionCallback});

  Widget _popup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(Strings.update),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(Strings.resetApp),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 1:
              loadReplacements();
              break;

            case 2:
              {
                Settings settings = Settings();
                settings.reset().then((value) {
                  returnToClassSelectionCallback();
                });
              }
              break;
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(Strings.representations),
        actions: <Widget>[_popup()],
      ),
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: loadReplacements,
        child: ListView.builder(
            itemCount: listWidgets.length,
            itemBuilder: (BuildContext context, int index) {
              return listWidgets[index];
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      loadReplacements();
    });
  }

  Future loadReplacements() async {
    setState(() {
      listWidgets = [];
    });

    Settings settings = Settings();
    String enabledClassJsonList =
        (await settings.getString(SettingStrings.classListSetting));

    //load data
    Map<String, dynamic>? data = await Request.fetchReplacements(
        http.Client(), context, password, enabledClassJsonList);

    //check if there is data
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Strings.couldNotLoadData),
      ));
      return;
    }

    Map<String, List<Widget>> map = {};

    //parse classes
    List<dynamic> classes = data['Classes'];
    map.addAll(parseReplacements(classes));

    //parse announcements
    try {
      List<dynamic> announcements = data['Additional_Information'];

      List<Widget> announcementList = parseAnnouncements(announcements);

      map[Strings.announcements] = announcementList;
    } catch (_) {}

    //now create into final list of widgets
    Iterable<String> keys = map.keys;
    List<Widget> list = [];

    for (String key in keys) {
      String? expanded = await settings.getString(key + '_expanded');
      if (expanded == null) {
        expanded = 'false';
      }

      list.add(ExpansionWidget(
        title: key,
        expanded: expanded.toLowerCase() == 'true',
        replacements: map[key]!,
      ));
    }

    //set list of widgets
    setState(() {
      listWidgets = list;
    });
  }

  String getWeekDayName(String dateString) {
    int weekDay = DateFormat('dd.MM.yyyy').parse(dateString).weekday;
    String dayName = '';

    switch (weekDay) {
      case 1:
        dayName = Strings.monday;
        break;

      case 2:
        dayName = Strings.tuesday;
        break;

      case 3:
        dayName = Strings.wednesday;
        break;

      case 4:
        dayName = Strings.thursday;
        break;

      case 5:
        dayName = Strings.friday;
        break;
    }

    return dayName;
  }

  bool dayIsCurrent(String dateString) {
    return DateFormat('dd.MM.yyyy').format(DateTime.now()).toString() ==
        dateString;
  }

  Map<String, List<Widget>> parseReplacements(List<dynamic> classes) {
    Map<String, List<Widget>> classesMap = {};

    for (dynamic schoolClass in classes) {
      String className = schoolClass['Class'];
      List<dynamic> dayArray = schoolClass['Days'];

      List<Widget> classReplacementList = [];

      for (dynamic day in dayArray) {
        classReplacementList.add(DayWidget(
          date: getWeekDayName(day['Date']) + ' ' + day['Date'],
          dateIsCurrent: dayIsCurrent(day['Date']),
        ));

        if (day['Replacements'].length > 0) {
          for (dynamic replacement in day['Replacements']) {
            classReplacementList.add(ReplacementWidget(
              comment: replacement['Comment'],
              room: replacement['Room'],
              hour: replacement['Hour'],
            ));
          }
        } else {
          classReplacementList.add(HtmlListTile(
            title: Strings.noRepresentations,
          ));
        }
      }

      classesMap[className] = classReplacementList;
    }

    return classesMap;
  }

  List<Widget> parseAnnouncements(List<dynamic> announcements) {
    List<Widget> announcementWidgets = [];

    for (dynamic announcement in announcements) {
      announcementWidgets.add(DayWidget(
        date: getWeekDayName(announcement['date']) + ' ' + announcement['date'],
        dateIsCurrent: dayIsCurrent(announcement['date']),
      ));

      String? appointment = announcement['appointment'];

      if (appointment != null) {
        announcementWidgets.add(HtmlListTile(
          title: announcement['appointment'],
        ));
      } else {
        announcementWidgets.add(HtmlListTile(title: Strings.noAnnouncements));
      }
    }

    return announcementWidgets;
  }
}
