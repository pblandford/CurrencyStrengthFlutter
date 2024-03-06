import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttersandpit/entities/Alert.dart';
import 'package:get_it/get_it.dart';
import 'package:fluttersandpit/data/AlertDb.dart';
import 'package:http/http.dart' as http;

import '../../data/Config.dart';

class DeleteAlert {
  final _alertDb = GetIt.I<AlertDb>();

  Future<void> call(Alert alert) async {
    String token = await FirebaseMessaging.instance.getToken() ?? "";
    return http.post(Uri.parse("${Config.serverUrl}/alert/delete"), body: {
      'regid': token,
      'period': alert.period.name,
      'sample': alert.sample.toString(),
      'threshold': alert.threshold.toStringAsFixed(2)
    }).then((_) => _alertDb.delete(alert.id));
  }
}
