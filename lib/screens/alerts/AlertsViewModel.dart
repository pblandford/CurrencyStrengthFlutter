import 'package:fluttersandpit/usecases/addalert/AddAlert.dart';
import 'package:fluttersandpit/usecases/deletealert/DeleteAlert.dart';
import 'package:fluttersandpit/usecases/getalerts/GetAlerts.dart';
import 'package:fluttersandpit/usecases/getsampleoptions/GetSampleOptions.dart';
import 'package:get_it/get_it.dart';
import 'package:view_model_x/view_model_x.dart';
import '../base/BaseViewModel.dart';
import 'AlertsModel.dart';
import 'package:fluttersandpit/entities/Alert.dart';

class AlertsViewModel extends BaseViewModel {
  final _getSampleOptions = GetIt.I<GetSampleOptions>();
  final _addAlert = GetIt.I<AddAlert>();
  final _deleteAlert = GetIt.I<DeleteAlert>();
  final _getAlerts = GetIt.I<GetAlerts>();

  final state = StateFlow(const AlertsModel([]));

  void updateAlerts() {
   usecase(() =>_getAlerts().then((alerts) {
      print("got alerts");
      state.value = AlertsModel(alerts);
    }));
  }

  void addAlert(Alert alert) {
    usecase(() => _addAlert(alert).then((_)  {
      print("add success");
      updateAlerts();
    }));
  }

  void deleteAlert(Alert alert) {
    usecase(() => _deleteAlert(alert).then((_) => updateAlerts()));
  }

  List<int> getSampleOptions() => _getSampleOptions();
}
