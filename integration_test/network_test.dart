import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fluttersandpit/usecases/getpercentsets/GetPercentSets.dart' as network;
import 'package:fluttersandpit/entities/PercentSet.dart';
import 'package:fluttersandpit/entities/Period.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final getPercentSets = network.GetPercentSets();

  group('test getting percent sets', () {

    test('samples are deserialized', () {

     Future<Iterable<PercentSet>> future = getPercentSets(Period.M5, 10);
      future.then((value) {
        expect(value.length, equals(8));
        for (var element in value) {
          expect(element.percentages.length, equals(10));
        }
      });
      expect(future, completes);
    });
  });
}