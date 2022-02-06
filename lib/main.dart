import 'package:carerstimelogger/Extensions.dart';
import 'package:carerstimelogger/carertopaydetails/CarerToPayDetailsWidget.dart';
import 'package:carerstimelogger/navigation/NavigationEvent.dart';
import 'package:carerstimelogger/navigation/NavigationState.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'carerstopaylist/CarersToPayListWidget.dart';
import 'firebase_options.dart';

import 'navigation/NavigationBloc.dart';
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
    return BlocProvider<NavigationBloc>(
      create: (_) => NavigationBloc()..add(PayShiftsEvent()),
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es','CO'),
        ],
        home: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is PayShiftsState) {
              return CarersToPayListWidget();
            }
            else if (state is PayShiftsDetailsState){
              return CarerToPayDetailsWidget(carerId: state.carerId);
            }
            else{
              return Text("Not Found");
            }
        }
        )
    ,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}


