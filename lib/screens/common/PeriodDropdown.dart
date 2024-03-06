import 'package:flutter/material.dart';
import 'package:fluttersandpit/entities/Period.dart';

class PeriodDropdown extends StatelessWidget {
  const PeriodDropdown(this.period, this.setPeriod, {super.key});
  final Function(Period) setPeriod;
  final Period period;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Period>(
      dropdownColor: Theme.of(context).colorScheme.surface,
        itemHeight: 50,
        value: period,
        onChanged: (p) {
          if (p != null) {
            setPeriod(p);
          }
        },
        items: Period.values
            .map((p) => DropdownMenuItem(value: p, child:Text(p.name)))
            .toList());
  }
}
