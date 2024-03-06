import 'package:fluttersandpit/usecases/getpercentsets/GetPercentSets.dart';
import 'package:fluttersandpit/screens/charts/ChartsModel.dart';
import 'package:fluttersandpit/entities/Period.dart';
import 'package:fluttersandpit/entities/PercentSet.dart';
import 'package:fluttersandpit/entities/Currency.dart';
import 'package:fluttersandpit/usecases/getsampleoptions/GetSampleOptions.dart';
import 'package:view_model_x/view_model_x.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../base/BaseViewModel.dart';

const int _defaultSample = 50;
const Period _defaultPeriod = Period.M5;

class ChartsViewModel extends BaseViewModel {
  final state =
      StateFlow(ChartsModel(LineChartData(), _defaultPeriod, _defaultSample));
  final _getPercentSets = GetIt.I<GetPercentSets>();
  final _getSampleOptions = GetIt.I<GetSampleOptions>();

  void getData(Period period, int sample) {
    usecase(() =>  _getPercentSets(period, sample).then((sets) {
      _convertData(sets);
    }));
  }

  void updatePeriod(Period period) {
    state.value =
        ChartsModel(state.value.lineChartData, period, state.value.sample);
    update();
  }

  void updateSample(int sample) {
    state.value =
        ChartsModel(state.value.lineChartData, state.value.period, sample);
    update();
  }

  List<int> getSampleOptions() {
    return _getSampleOptions();
  }

  Period getDefaultPeriod() {
    return _defaultPeriod;
  }

  int getDefaultSample() {
    return _defaultSample;
  }

  void update() {
    getData(state.value.period, state.value.sample);
  }

  void _convertData(Iterable<PercentSet> percentSets) {
    final data = percentSets.map((set) {
      final spots = set.percentages
          .mapIndexed((idx, value) => FlSpot(idx.toDouble(), value))
          .toList();
      return LineChartBarData(
          spots: spots,
          color: set.currency.getColor(),
          dotData: const FlDotData(show: false));
    }).toList();
    final lcd = LineChartData(
        lineBarsData: data,
        titlesData: const FlTitlesData(show: false));
    state.value = ChartsModel(lcd, state.value.period, state.value.sample);
  }

}


extension GetColor on Currency {
  Color getColor() {
    switch (this) {
      case Currency.USD:
        return Colors.green;
      case Currency.AUD:
        return Colors.blue;
      case Currency.NZD:
        return Colors.yellow;
      case Currency.GBP:
        return Colors.red;
      case Currency.EUR:
        return Colors.cyan;
      case Currency.JPY:
        return Colors.white;
      case Currency.CHF:
        return Colors.purpleAccent;
      case Currency.CAD:
        return Colors.cyan;
      default:
        return Colors.black;
    }
  }
}
