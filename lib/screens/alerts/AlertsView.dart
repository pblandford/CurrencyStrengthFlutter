import 'package:flutter/material.dart';
import 'package:fluttersandpit/entities/Currency.dart';
import 'package:view_model_x/view_model_x.dart';
import 'AlertCreate.dart';
import 'AlertsViewModel.dart';
import 'package:fluttersandpit/entities/Alert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlertsView extends StatelessWidget {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      create: (_) => AlertsViewModel(),
      child: const _AlertsBody(),
    );
  }
}

class _AlertsBody extends StatelessWidget {
  const _AlertsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final AlertsViewModel viewModel = context.vm<AlertsViewModel>();

    viewModel.updateAlerts();

    return StateFlowBuilder(
        stateFlow: viewModel.state,
        builder: (context, value) {
          return _AlertsScaffold(value.alerts, viewModel.getSampleOptions(),
              (a) => viewModel.addAlert(a), (a) => viewModel.deleteAlert(a));
        });
  }
}

class _AlertsScaffold extends StatelessWidget {
  const _AlertsScaffold(
      this.alerts, this.sampleOptions, this.create, this.delete);

  final List<Alert> alerts;
  final List<int> sampleOptions;
  final Function(Alert) create;
  final Function(Alert) delete;

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(AppLocalizations.of(context)!.createAlert),
              content: AlertCreate(create, sampleOptions));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Theme.of(context).colorScheme.surface,
            child: _AlertsList(alerts, delete)),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () => _showDialog(context),
          child: const Icon(Icons.add),
        ));
  }
}

class _AlertsList extends StatelessWidget {
  const _AlertsList(this.alerts, this.delete);

  final List<Alert> alerts;
  final Function(Alert) delete;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: alerts
          .map((e) => Column(children: [
                _AlertRow(e, delete),
                const SizedBox(
                  height: 20,
                )
              ]))
          .toList(),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow(this.alert, this.delete);

  final Alert alert;
  final Function(Alert) delete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(alert.period.name)),
        Expanded(flex: 1, child: Text(alert.sample.toString())),
        Expanded(flex: 1, child: Text(alert.threshold.toStringAsFixed(2))),
        Expanded(flex: 1, child: Text(_formatCurrencyPair(alert))),
        Expanded(flex: 1, child: _DeleteButton(() => delete(alert)))
      ],
    );
  }
}

String _formatCurrencyPair(Alert alert) {
  return "${_formatCurrency(alert.lastPair.$1)}/${_formatCurrency(alert.lastPair.$2)}";
}

String _formatCurrency(Currency currency) {
  if (currency == Currency.NONE) {
    return " - ";
  } else {
    return currency.name;
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton(this.delete);

  final Function() delete;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => showAlert(context), icon: const Icon(Icons.delete));
  }

  showAlert(BuildContext context) {
    Widget cancelButton = TextButton(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.onSurface
        )),
      child: Text(AppLocalizations.of(context)!.ok),
      onPressed: () {
        delete();
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      style: ButtonStyle(foregroundColor: MaterialStateProperty.all(
        Theme.of(context).colorScheme.onSurface
      )),
      child: Text(AppLocalizations.of(context)!.cancel),
      onPressed: () => Navigator.of(context).pop(),
    );
    AlertDialog alert = AlertDialog(
      surfaceTintColor: Theme.of(context).colorScheme.onSurface,
      backgroundColor:  Colors.black, //Theme.of(context).colorScheme.surface,

      content: Text(AppLocalizations.of(context)!.deleteConfirm),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
