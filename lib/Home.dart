import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vertretungsplan/pages/ClassListPage.dart';
import 'package:vertretungsplan/pages/ReplacmentListPage.dart';
import 'package:vertretungsplan/util/Settings.dart';

import 'constants/SettingStrings.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    _HomeState _homeState = _HomeState();
    return _homeState;
  }
}

class _HomeState extends State<Home> {
  Widget currentPage = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      //old android devices dont accept the newer SSL certificate, this will ignore all SSL errors on those devices (which is a huge security risk but who cares)
      await setupSSLOverride();

      Settings settings = Settings();

      //check if password and stuff are set, if not show the page with password prompt
      if (await settingsNotNull(settings)) {
        showReplacementListPage(
            await settings.getString(SettingStrings.passwordSetting));
      } else {
        showClassSelectionPage();
      }
    });
  }

  showClassSelectionPage() {
    setState(() {
      currentPage =
          ClassListPage(switchToReplacementsPage: showReplacementListPage);
    });
  }

  showReplacementListPage(String password) {
    setState(() {
      currentPage = ReplacementListPage(
          password: password,
          returnToClassSelectionCallback: showClassSelectionPage);
    });
  }

  static const platformMethodChannel =
      const MethodChannel('de.lucaspape.vertretungsplan/native');

  setupSSLOverride() async {
    try {
      if (await platformMethodChannel
          .invokeMethod('disableSSLCertificateChecking')) {
        print('Security warning: disabling certificate checks!');
        HttpOverrides.global = new HttpCertOverrides();
      }
    } on MissingPluginException catch (_) {}
  }

  Future<bool> settingsNotNull(Settings settings) async {
    return await settings.getString(SettingStrings.classListSetting) != null &&
        await settings.getString(SettingStrings.classListSetting) != '' &&
        await settings.getString(SettingStrings.passwordSetting) != null &&
        await settings.getString(SettingStrings.passwordSetting) != '';
  }
}

class HttpCertOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(ignoreBadCertificateClient);

  HttpClient ignoreBadCertificateClient(SecurityContext context) {
    HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}
