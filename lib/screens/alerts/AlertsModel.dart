import 'package:fluttersandpit/entities/Alert.dart';
import 'package:equatable/equatable.dart';


class AlertsModel extends Equatable {
  const AlertsModel(this.alerts);

  final List<Alert> alerts;

  @override
  List<Object> get props => [alerts];
}
