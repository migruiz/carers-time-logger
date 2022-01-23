import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsBloc.dart';
import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'UnpaidShiftsEvent.dart';

class UnpaidShiftsWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => UnpaidShiftsBloc()..add(LoadDataEvent()),
        child: BlocBuilder<UnpaidShiftsBloc, UnpaidShiftsState>(
            builder: (context, state) {
              if (state is LoadedState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Turnos por pagar de {Carer}"),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Timesheet goes here',
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('REGISTRAR TURNO',
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                    )
                                    ,
                                    SizedBox(
                                      width: double.infinity,
                                      // height: double.infinity,
                                      child: Container(
                                        color: Colors.green,
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                            "Total Horas Trabajadas: 14",
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                    )
                                  ],
                                )))
                      ],
                    ),
                  ),
                );
              }
              else{
                return Container();
              }
            }
        ),
      ),
    );
  }

}