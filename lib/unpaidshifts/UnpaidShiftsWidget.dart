import 'package:carerstimelogger/Extensions.dart';
import 'package:carerstimelogger/registerunpaidshift/RegisterUnpaidShiftWidget.dart';
import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsBloc.dart';
import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'UnpaidShiftsEvent.dart';

class UnpaidShiftsWidget extends StatelessWidget{
  final String carerId;

  const UnpaidShiftsWidget({Key? key, required this.carerId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es','CO'),
        ],
      home: BlocProvider(
        create: (_) => UnpaidShiftsBloc()..add(LoadDataEvent(carerId: carerId)),
        child: BlocBuilder<UnpaidShiftsBloc, UnpaidShiftsState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<UnpaidShiftsBloc>(context);
              if (state is LoadedState) {
                final shifts = state.shifts;
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Turnos por pagar de ${state.carer.nickname}"),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                    Expanded(
                    child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(8),
                            shrinkWrap: true,
                            itemCount: shifts.length,
                            itemBuilder: (BuildContext context, int index) {
                              final shift = shifts[index];
                              return InkWell(
                                  onTap: () async{
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (BuildContext context) =>
                                                RegisterUnpaidShiftWidget(carerId: this.carerId,shiftId: shift.id,)));

                                    bloc.add(LoadDataEvent(carerId: this.carerId));
                                  },
                                  child: Column(

                                      children: [
                                Row(
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            shift.start
                                                .fromLocalToColombianTime()
                                                .formatDateTime()
                                                .toCapitalized(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left:20),
                                              child:Text("↓",style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                          Text(
                                            shift.end
                                                .fromLocalToColombianTime()
                                                .formatDateTime()
                                                .toCapitalized(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                          Container(height: 10,),
                                          ...shift.overlappedShifts.entries.map((e) => Text(e.key.carerName +' '+  e.key.start
                                              .fromLocalToColombianTime()
                                              .formatDateTime()
                                              .toCapitalized() + ' -> ' + e.key.end
                                              .fromLocalToColombianTime()
                                              .formatDateTime()
                                              .toCapitalized() + '   = ' +(e.value / (1000 * 60 * 60)).toStringAsFixed(1) ))
                                        ]),
                                    Expanded(
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              "${shift.hours}h @ ${shift.overlappedHours}h",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            )))
                                  ],
                                ),
                                Divider(
                                  height: 40,
                                  thickness: 1,
                                )
                              ]));
                            }
                        )),
                        Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        onPressed: () async{

                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (BuildContext context) =>
                                                      RegisterUnpaidShiftWidget(carerId: this.carerId,shiftId: null,)));

                                            bloc.add(LoadDataEvent(carerId: this.carerId));
                                        },
                                        child: Text('REGISTRAR TURNO',
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                    )
                                    ,
                                    SizedBox(
                                      width: double.infinity,
                                      // height: double.infinity,
                                      child: Container(
                                        color: Colors.black87,
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                            "TOTAL HORAS TRABAJADAS: ${state.totalHours.toStringAsFixed(1)}",
                                            style: TextStyle(fontSize: 20, color: Colors.white)),
                                      ),
                                    )
                                  ],
                                ))
                      ],
                    ),
                  ),
                );
              }
              if (state is LoadingState){
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Turnos por pagar"),
                  ),
                  body: Align(
                    child: Container(
                      width: 135,
                      height: 100,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Loading..."),
                          Container(height: 20),
                          Container( height: 4,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
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