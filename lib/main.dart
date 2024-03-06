import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttersandpit/base/InitDI.dart';
import 'package:fluttersandpit/screens/top/TopView.dart';
import 'package:fluttersandpit/usecases/checkin/CheckIn.dart';
import 'package:fluttersandpit/usecases/listenfornotifications/ListenForNotifications.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  initDI();
  final listen = GetIt.I<ListenForNotifications>();
  listen().then((value) => runApp(const MyApp()));
  final checkIn = GetIt.I<CheckIn>();
  checkIn().onError((error, stackTrace) => print("Checkin failed $error"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ColorScheme get scheme => ColorScheme.fromSeed(seedColor: Colors.white)
      .copyWith(surface: Colors.black, onSurface: Colors.white, surfaceTint: Colors.white
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
            useMaterial3: true,
            buttonTheme: ButtonThemeData(
                colorScheme: scheme, textTheme: ButtonTextTheme.normal),
            iconTheme: const IconThemeData(color: Colors.white),
            iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            )),
            colorScheme: scheme),
        supportedLocales: const [Locale('en'), Locale('cy')],
        home: const TopView());
  }
}
