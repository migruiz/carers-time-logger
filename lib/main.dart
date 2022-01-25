import 'package:carerstimelogger/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';

import 'unpaidshifts/UnpaidShiftsWidget.dart';

void main() async {



  Intl.defaultLocale = 'es_CO';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
        onGenerateRoute: (settings) {
        final routingData = settings.name?.getRoutingData;
        if (routingData==null)
          return null;
          if (routingData.route=='unpaidshifts') {
            return MaterialPageRoute(
              builder: (context) {
                return UnpaidShiftsWidget(carerId: routingData.queryParameters['carer']!,);
              },
            );
          }
        }
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnpaidShiftsWidget(carerId: 'miguel',);
    return MaterialApp(
    home: Text("Not Found")
    );
  }
}
