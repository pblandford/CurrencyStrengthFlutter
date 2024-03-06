import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttersandpit/entities/Currency.dart';
import 'package:get_it/get_it.dart';
import 'package:view_model_x/view_model_x.dart';
import 'package:fluttersandpit/screens/charts/ChartsViewModel.dart';
import 'package:fluttersandpit/entities/Period.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluttersandpit/screens/common/PeriodDropdown.dart';
import 'package:fluttersandpit/screens/common/SampleDropdown.dart';

class ChartsView extends StatelessWidget {
  const ChartsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
        create: (_) => GetIt.I<ChartsViewModel>(), child: const _ChartsBody());
  }
}

class _ChartsBody extends StatelessWidget {
  const _ChartsBody();

  @override
  Widget build(BuildContext context) {
    final ChartsViewModel viewModel = context.vm<ChartsViewModel>();
    viewModel.update();

    return StateFlowBuilder(
        stateFlow: viewModel.state,
        builder: (context, value) {
          return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _SelectionRow(value.period, value.sample, (p) {
                    viewModel.updatePeriod(p);
                  }, (i) {
                    viewModel.updateSample(i);
                  }, viewModel.getSampleOptions(), () => viewModel.update()),
                  SizedBox(height: 300, child: _Chart(value.lineChartData)),
                  const SizedBox(height: 20),
                  _Legend()
                ],
              ));
        });
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow(this.period, this.sample, this.setPeriod, this.setSample,
      this.sampleOptions, this.refresh);

  final Period period;
  final int sample;
  final Function(Period) setPeriod;
  final Function(int) setSample;
  final List<int> sampleOptions;
  final Function() refresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PeriodDropdown(period, setPeriod),
        SampleDropdown(sample, setSample, sampleOptions),
        Expanded(flex: 1, child: Container()),
        IconButton(onPressed: () => refresh(), icon: const Icon(Icons.refresh))
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart(this.lineChartData);

  final LineChartData lineChartData;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: LineChart(lineChartData));
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        childAspectRatio: 4,
        children: Currency.values
            .where((element) => element != Currency.NONE)
            .map((c) => SizedBox(
                height: 10,
                child: Row(
                  children: [
                    Container(color: c.getColor(), width: 10, height: 10),
                    Container(width: 10),
                    Text(c.name)
                  ],
                )))
            .toList());
  }
}
