import 'package:fluttersandpit/data/AlertDb.dart';
import 'package:fluttersandpit/errors/ErrorHandler.dart';
import 'package:fluttersandpit/screens/charts/ChartsViewModel.dart';
import 'package:fluttersandpit/usecases/addalert/AddAlert.dart';
import 'package:fluttersandpit/usecases/deletealert/DeleteAlert.dart';
import 'package:fluttersandpit/usecases/getalerts/GetAlerts.dart';
import 'package:fluttersandpit/usecases/getsampleoptions/GetSampleOptions.dart';
import 'package:fluttersandpit/usecases/listenfornotifications/ListenForNotifications.dart';
import 'package:fluttersandpit/usecases/checkin/CheckIn.dart';
import 'package:fluttersandpit/usecases/getpercentsets/GetPercentSets.dart';
import 'package:get_it/get_it.dart';


void initDI() {
  GetIt.I.registerSingleton(ErrorHandler());
  GetIt.I.registerSingleton(AlertDb());
  GetIt.I.registerSingleton(GetPercentSets());
  GetIt.I.registerSingleton(CheckIn());
  GetIt.I.registerSingleton(GetAlerts());
  GetIt.I.registerSingleton(AddAlert());
  GetIt.I.registerSingleton(DeleteAlert());
  GetIt.I.registerSingleton(GetSampleOptions());
  GetIt.I.registerSingleton(ListenForNotifications());
  GetIt.I.registerSingleton(ChartsViewModel());
}
