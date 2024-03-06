import 'package:sqflite/sqflite.dart';
import 'package:fluttersandpit/entities/Alert.dart';

class AlertDb {
  late final Future<Database> db;

  AlertDb() {
    db = openDatabase(_dbName, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(_create);
    });
  }

  Future<List<Alert>> getAlerts() async {
    return db.then((db) => db.query(AlertDb.TABLE_ALERTS, columns: [
          COLUMN_PERIOD,
          COLUMN_SAMPLE,
          COLUMN_THRESHOLD,
          COLUMN_LASTPAIR,
          COLUMN_LASTALERT,
          COLUMN_LASTUPDATE,
          COLUMN_ID
        ]).then((list) => list.map((m) {
              print("Got amp $m");
              return Alert.fromMap(m);
            }).toList()));
  }

  Future<int> insert(Alert alert) async {
    // final queryResult = await db.then((db) => db.query(AlertDb.TABLE_ALERTS,
    //         where:
    //             "$COLUMN_PERIOD = ? and $COLUMN_SAMPLE = ? and $COLUMN_THRESHOLD = ?",
    //         whereArgs: [
    //           alert.period.name,
    //           alert.sample,
    //           alert.threshold.roundToOnePlace()
    //         ]));
    // if (queryResult.isNotEmpty) {
    //   print("Exists");
    //   return Future.error("Combination exists");
    // }

    return db.then((db) => db.insert(TABLE_ALERTS, alert.toMap()));
  }

  Future<int> update(Alert alert) async {
    return db.then((db) =>
        db.update(TABLE_ALERTS, alert.toMap(), where: "$COLUMN_ID = ?",
        whereArgs: [alert.id]));
  }

  Future<void> clear() async {
    return db.then((db) => db.delete(TABLE_ALERTS));
  }

  Future<void> delete(int id) async {
    return db.then((db) =>
        db.delete(TABLE_ALERTS, where: '$COLUMN_ID = ?', whereArgs: [id]));
  }

  static const TABLE_ALERTS = "alerts";
  static const COLUMN_PERIOD = "period";
  static const COLUMN_ID = "_id";
  static const COLUMN_SAMPLE = "sample";
  static const COLUMN_THRESHOLD = "threshold";
  static const COLUMN_LASTPAIR = "lastpair";
  static const COLUMN_LASTUPDATE = "lastupdate";
  static const COLUMN_LASTALERT = "lastalert";

  static const String _dbName = "alerts.db";
  final String _create =
      "CREATE TABLE $TABLE_ALERTS ($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$COLUMN_PERIOD TEXT, $COLUMN_SAMPLE INTEGER, $COLUMN_THRESHOLD REAL, "
      "$COLUMN_LASTPAIR TEXT, $COLUMN_LASTALERT INTEGER,  $COLUMN_LASTUPDATE INTEGER) ";
}

extension Rounding on double {
  double roundToTwoPlaces() => double.parse(toStringAsFixed(2));
}
