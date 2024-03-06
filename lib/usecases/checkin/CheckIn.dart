import 'dart:convert';
import 'package:fluttersandpit/data/AlertDb.dart';
import 'package:fluttersandpit/data/Config.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _FCM_KEY = "FCM";

class CheckIn {
  final alertDb = GetIt.I<AlertDb>();

  Future<void> call() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String old = _preferences.getString(_FCM_KEY) ?? "";
    String current = await FirebaseMessaging.instance.getToken() ?? "";
    await _preferences.setString(_FCM_KEY, current);

    final alerts = await alertDb.getAlerts();
    String alertJson = jsonEncode(alerts);

    final map = {'regid': current, 'alerts': alertJson};
    if (old.isNotEmpty && old != current) {
      map.addAll({'oldregid': old});
    }

    return http
        .post(Uri.parse("${Config.serverUrl}/checkin"), body: map)
        .then((value) => {});
  }
}
