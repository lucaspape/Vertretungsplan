import 'dart:convert';

import 'package:vertretungsplan/constants/ApiStrings.dart';
import 'package:http/http.dart' as http;
import 'package:vertretungsplan/constants/SettingStrings.dart';
import 'package:vertretungsplan/constants/Strings.dart';
import 'package:vertretungsplan/util/Settings.dart';

class Request {
  static Future<List<String>?> fetchClasses(
      http.Client client, String password) async {
    final response = await client
        .get(Uri.parse('${ApiStrings.CLASS_URL}?password=$password'));

    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);

      final List<String> classList = [];

      for (dynamic item in parsed) {
        classList.add(item);
      }

      return classList;
    } else {
      print(Strings.networkError);

      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchReplacements(http.Client client,
      dynamic context, String password, String jsonClasses) async {
    final response = await client.get(Uri.parse(
        '${ApiStrings.PLAN_URL}?password=$password&classes=$jsonClasses'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);

      return parsed;
    } else if (response.statusCode == 401) {
      Settings().setString(SettingStrings.passwordSetting, '');
      print(Strings.wrongPassword);
      return null;
    } else {
      print(Strings.networkError);
      return null;
    }
  }
}
