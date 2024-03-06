import 'package:flutter/material.dart';
import 'package:fluttersandpit/entities/Alert.dart';
import 'package:fluttersandpit/entities/Period.dart';
import 'package:fluttersandpit/screens/common/PeriodDropdown.dart';
import 'package:fluttersandpit/screens/common/SampleDropdown.dart';

class AlertCreate extends StatefulWidget {
  const AlertCreate(this.create, this.sampleOptions, {super.key});

  final Function(Alert) create;
  final List<int> sampleOptions;

  @override
  State<StatefulWidget> createState() => _AlertCreateBody();
}

class _AlertCreateBody extends State<AlertCreate> {
  Period period = Period.M5;
  int sample = 50;
  double threshold = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OptionsRow(
                period,
                sample,
                widget.sampleOptions,
                (p) => setState(() => period = p),
                (s) => setState(() => sample = s)),
            _ThresholdSlider(threshold, (t) => setState(() => threshold = t)),
            OutlinedButton(
                onPressed: () {
                  widget.create(Alert(period, sample, threshold));
                  Navigator.of(context).pop();
                },
                child: const Text("Create", ))
          ],
        );
  }
}

class _OptionsRow extends StatelessWidget {
  const _OptionsRow(this.period, this.sample, this.sampleOptions,
      this.setPeriod, this.setSample);

  final Period period;
  final int sample;
  final List<int> sampleOptions;
  final Function(Period) setPeriod;
  final Function(int) setSample;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Expanded(child: PeriodDropdown(period, setPeriod)),
      Expanded(child: SampleDropdown(sample, setSample, sampleOptions))
    ]);
  }
}

class _ThresholdSlider extends StatelessWidget {
  const _ThresholdSlider(this.threshold, this.setThreshold);

  final double threshold;
  final Function(double) setThreshold;

  @override
  Widget build(BuildContext context) {
    return Slider(
        value: threshold, min: 0.1, max: 2.0, onChanged: setThreshold);
  }
}
