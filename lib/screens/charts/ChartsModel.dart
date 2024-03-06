import 'package:equatable/equatable.dart';
import 'package:fluttersandpit/entities/PercentSet.dart';
import 'package:fluttersandpit/entities/Period.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartsModel extends Equatable {
  const ChartsModel(this.lineChartData, this.period, this.sample);

  final LineChartData lineChartData;
  final Period period;
  final int sample;

  @override
  List<Object> get props => [lineChartData, period, sample];
}