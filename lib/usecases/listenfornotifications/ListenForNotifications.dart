import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttersandpit/data/AlertDb.dart';
import 'package:fluttersandpit/entities/Alert.dart';
import '../../firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.data}");
  await _handleAlert(message.data);
}

late FlutterLocalNotificationsPlugin notificationsPlugin;

class ListenForNotifications {
  Future<void> call() async {
    await _initFirebase();
    await _initNotifications();
    FirebaseMessaging.onMessage.listen((event) {
      _handleAlert(event.data);
    });
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

_initNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const settings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);
  notificationsPlugin = FlutterLocalNotificationsPlugin()..initialize(settings);
}

_handleAlert(Map<String, dynamic> messageData) async {
  var alert = Alert.fromStringMap(messageData);
  print("Handle alert $alert");
  _updateAlert(alert);
  _showNotification(alert);
}

_updateAlert(Alert alert) async {
  final alertDb = AlertDb();
  print("Handling $alert");
  final dbAlert = await alertDb.getAlerts().then((value) => value.firstWhere(
      (element) =>
          element.threshold.roundToTwoPlaces() ==
              alert.threshold.roundToTwoPlaces() &&
          element.sample == alert.sample &&
          element.period == alert.period));
  print("dbAlert $dbAlert");

  var newAlert = Alert(
      dbAlert.period,
      dbAlert.sample,
      dbAlert.threshold,
      alert.lastPair,
      DateTime.now().millisecondsSinceEpoch,
      DateTime.now().microsecondsSinceEpoch,
      dbAlert.id);
  await alertDb.update(newAlert);
}

const String CHANNEL_ID = "CSI";
const String CHANNEL_NAME = "ALERT";
var idCtr = 0;

_showNotification(Alert alert) async {
  const androidSpecifics = AndroidNotificationDetails(CHANNEL_ID, CHANNEL_NAME);
  const iosSpecifics = DarwinNotificationDetails();
  const platformSpecifics =
      NotificationDetails(android: androidSpecifics, iOS: iosSpecifics);
  final text =
      "${alert.lastPair.$1.name} / ${alert.lastPair.$2.name}  ${alert.period.name} "
      "${alert.sample} ${alert.threshold}";
  final id = (alert.period, alert.sample, alert.threshold).hashCode;
  await notificationsPlugin.show(
      id, "Currency shift", text, platformSpecifics);
}
