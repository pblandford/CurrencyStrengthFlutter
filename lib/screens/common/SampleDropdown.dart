import 'package:flutter/material.dart';

class SampleDropdown extends StatelessWidget {
  const SampleDropdown(this.sample, this.setSample, this.options, {super.key});
  final Function(int) setSample;
  final int sample;
  final List<int> options;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
        dropdownColor: Theme.of(context).colorScheme.surface,
        itemHeight: 50.0,
        value: sample,
        onChanged: (i) {
          if (i != null) {
            setSample(i);
          }
        },
        items: options
            .map((i) => DropdownMenuItem(
                  value: i,
                  child: Text(i.toString()),
                ))
            .toList());
  }
}
