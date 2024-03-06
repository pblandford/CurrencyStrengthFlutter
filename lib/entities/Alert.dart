import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttersandpit/data/AlertDb.dart';
import 'Period.dart';
import 'Currency.dart';

class Alert extends Equatable {
  const Alert(this.period, this.sample, this.threshold,
      [this.lastPair = (Currency.NONE, Currency.NONE),
      this.lastAlert = 0,
      this.lastUpdate = 0,
      this.id = -1]);

  final Period period;
  final int sample;
  final double threshold;
  final (Currency, Currency) lastPair;
  final int lastAlert;
  final int lastUpdate;
  final int id;

  @override
  List<Object> get props =>
      [period, sample, threshold, lastPair, lastAlert, lastUpdate, id];

  factory Alert.fromMap(Map<String, dynamic> map) => Alert(
      Period.values.byName(map[AlertDb.COLUMN_PERIOD]),
      map[AlertDb.COLUMN_SAMPLE] as int,
      map[AlertDb.COLUMN_THRESHOLD] as double,
      (
        Currency.fromString(
            (map[AlertDb.COLUMN_LASTPAIR] as String).split("/").first),
        Currency.fromString(
            (map[AlertDb.COLUMN_LASTPAIR] as String).split("/").last)
      ),
      map[AlertDb.COLUMN_LASTALERT] as int,
      map[AlertDb.COLUMN_LASTUPDATE] as int,
      map[AlertDb.COLUMN_ID] as int);

  factory Alert.fromStringMap(Map<String, dynamic> map) => Alert(
          Period.values.byName(map['period']),
          int.parse(map['sample']),
          double.parse(map['threshold']), (
        Currency.fromString((map['lastPair'] as String).split('/').first),
        Currency.fromString((map['lastPair'] as String).split('/').last),
      ));

  Map<String, dynamic> toMap() => <String, dynamic>{
        AlertDb.COLUMN_PERIOD: period.name,
        AlertDb.COLUMN_SAMPLE: sample,
        AlertDb.COLUMN_THRESHOLD: threshold.roundToTwoPlaces(),
        AlertDb.COLUMN_LASTPAIR: "${lastPair.$1}/${lastPair.$2}",
        AlertDb.COLUMN_LASTALERT: lastAlert,
        AlertDb.COLUMN_LASTUPDATE: lastUpdate
      };

  Map<String, dynamic> toJson() => toMap();
}
