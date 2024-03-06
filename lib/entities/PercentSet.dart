import 'package:equatable/equatable.dart';
import 'Currency.dart';

class PercentSet extends Equatable {
  const PercentSet(this.currency, this.percentages);

  final Currency currency;
  final List<double> percentages;

  @override
  List<Object> get props => [currency, percentages];

  factory PercentSet.fromJson(Map<String, dynamic> json) =>
      PercentSet(Currency.values.byName(json['currency']),
          (json['percentages'] as List<dynamic>).map((e) => e as double).toList());
}
