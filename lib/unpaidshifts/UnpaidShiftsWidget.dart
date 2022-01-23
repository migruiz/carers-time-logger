import 'package:carerstimelogger/Extensions.dart';
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
                final shifts = state.shifts;
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Turnos por pagar de {Carer}"),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: shifts.length,
                            itemBuilder: (BuildContext context, int index) {
                              final shift = shifts[index];
                              return InkWell(
                                  onTap: () async{
                                  },
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Container(
                                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                                          child: Text(shift.start.formatDateTime(),style: TextStyle(color: Colors.black, fontSize: 16),),
                                        ),
                                        Text("a"),
                                        Container(
                                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                                          child: Text(shift.end.formatDateTime(),style: TextStyle(color: Colors.black, fontSize: 16),),
                                        ),
                                        Divider(height: 3,)
                                      ]
                                  ));
                            }
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