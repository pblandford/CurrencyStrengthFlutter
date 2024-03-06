import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersandpit/entities/PercentSet.dart';
import 'package:fluttersandpit/entities/Currency.dart';

void main() {

  group('test deserializing percent sets', () {
    test('test basic conversion', () {
      final map = { 'currency': Currency.USD, 'percentages': [ 0.2, 0.3, 0.4]};
      final percentSet = PercentSet.fromJson(map);
      expect(percentSet, equals(const PercentSet(Currency.USD,
          [0.2, 0.3, 0.4])
      ));
    });
  });
}