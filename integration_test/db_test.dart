import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fluttersandpit/data/AlertDb.dart';
import 'package:fluttersandpit/entities/Alert.dart';
import 'package:fluttersandpit/entities/Period.dart';
import 'package:fluttersandpit/entities/Currency.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final db = AlertDb();

  group("alert DB tests", () {
    setUp(() async {
      await db.clear();
    });

    test('get alerts with empty table', () {
      final future =
          db.getAlerts().then((alerts) => expect(alerts.length, equals(0)));
      expect(future, completes);
    });

    test('insert alert', () {
      final future = db
          .insert(Alert(Period.M5, 10, 1.0, (Currency.USD, Currency.JPY),
              DateTime.now().millisecondsSinceEpoch))
          .then((id) => expect(id, isNot(equals(-1))));
      expect(future, completes);
    });

    test('get alerts after insert', () {
      final alert = Alert(Period.M5, 10, 1.0, (Currency.USD, Currency.JPY),
          DateTime.now().millisecondsSinceEpoch);
      final future = db
          .insert(alert)
          .then((_) => db.getAlerts())
          .then((alerts) => expect(alerts.first, equals(alert)));
      expect(future, completes);
    });

    test('update alert', () {
      final alert = Alert(Period.M5, 10, 1.0, (Currency.USD, Currency.JPY),
          DateTime.now().millisecondsSinceEpoch);
      final future = db.insert(alert).then((id) {
        final updated = Alert(Period.M15, 20, 2.0, (Currency.USD, Currency.JPY),
            DateTime.now().millisecondsSinceEpoch, id = id);
        db.update(updated).then((value) {
          db
              .getAlerts()
              .then((alerts) => expect(alerts.first, equals(updated)));
        });
      });
      expect(future, completes);
    });

    test('delete alerts after insert', () {
      final alert = Alert(Period.M5, 10, 1.0, (Currency.USD, Currency.JPY),
          DateTime.now().millisecondsSinceEpoch);
      final future = db
          .insert(alert)
          .then((id) => db.delete(id))
          .then((_) => db.getAlerts())
          .then((alerts) => expect(alerts.length, equals(0)));
      expect(future, completes);
    });

    test('insert alert with same params gives error', () {
      const alert = Alert(Period.M5, 10, 1.0,);

      final future = db
          .insert(alert)
          .then((_) => db.insert(alert))
          .then((value) =>  throw "Should have failed");
      expect(future, completes);
    });
  });
}
