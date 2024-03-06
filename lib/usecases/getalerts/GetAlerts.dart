import 'package:fluttersandpit/data/AlertDb.dart';
import 'package:fluttersandpit/entities/Alert.dart';
import 'package:get_it/get_it.dart';

class GetAlerts {
  final _alertDb = GetIt.I<AlertDb>();

  Future<List<Alert>> call() async{
    return _alertDb.getAlerts();
  }
}