import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttersandpit/errors/ErrorHandler.dart';
import 'package:fluttersandpit/screens/charts/ChartsView.dart';
import 'package:fluttersandpit/screens/alerts/AlertsView.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttersandpit/screens/help/HelpView.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';

class TopView extends StatefulWidget {
  const TopView({super.key});

  @override
  State createState() => _TopViewState();
}

class _TopViewState extends State<TopView> {
  int _selected = 0;
  final _errorHandler = GetIt.I<ErrorHandler>();
  StreamSubscription<Exception>? _subscription = null;

  @override
  Widget build(BuildContext context) {
    _requestPermissions();

    _subscription ??= _errorHandler.errors.stream.listen((error) {
      _showError(context, error);
    });

    return Scaffold(
        appBar: AppBar(
          leading: _selected == 0
              ? const Icon(Icons.bar_chart)
              : const Icon(Icons.notifications),
          actions: [
            IconButton(
                onPressed: () => _showHelp(context),
                icon: const Icon(Icons.help))
          ],
          title: Text(_getTitle(context, _selected)),
        ),
        body: Container(
            color: Theme.of(context).colorScheme.surface,
            child: [const ChartsView(), const AlertsView()][_selected]),
        bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
                labelTextStyle: MaterialStateProperty.all(
                    TextStyle(color: Theme.of(context).colorScheme.onSurface))),
            child: NavigationBar(
              selectedIndex: _selected,
              onDestinationSelected: (int index) {
                setState(() {
                  _selected = index;
                });
              },
              destinations: [
                NavigationDestination(
                    icon: Icon(Icons.bar_chart,
                        color: Theme.of(context).colorScheme.onSurface),
                    label: _getTitle(context, 0)),
                NavigationDestination(
                    icon: Icon(Icons.notifications,
                        color: Theme.of(context).colorScheme.onSurface),
                    label: _getTitle(context, 1)),
              ],
            )));
  }

  String _getTitle(BuildContext context, int idx) {
    if (idx == 0) {
      return AppLocalizations.of(context)!.charts;
    } else {
      return AppLocalizations.of(context)!.alerts;
    }
  }

  _showHelp(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Dialog(
              child: HelpView(),
            ));
  }

  _requestPermissions() async {
    await Permission.notification.request();
    // nothing to do with result either way, they just won't get any notifications
  }

  _showError(BuildContext context, Exception exception) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text("Error"),
              content: Text(exception.toString()),
            ));
  }

  @override
  void dispose() {
    super.dispose();
    _errorHandler.errors.close();
    _subscription = null;
  }
}
