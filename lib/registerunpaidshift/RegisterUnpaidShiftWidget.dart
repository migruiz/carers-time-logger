import 'package:carerstimelogger/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'RegisterUnpaidShiftBloc.dart';
import 'RegisterUnpaidShiftEvent.dart';
import 'RegisterUnpaidShiftState.dart';

class RegisterUnpaidShiftWidget extends StatelessWidget{
  final String carerId;

  const RegisterUnpaidShiftWidget({Key? key,required this.carerId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (_) => RegisterUnpaidShiftBloc()..add(NewShiftEvent(carerId: carerId)),
        child: BlocBuilder<RegisterUnpaidShiftBloc, RegisterUnpaidShiftState>(
            builder: (context, state) {
              if (state is RegisterUnpaidShiftLoadedState) {
                final bloc = BlocProvider.of<RegisterUnpaidShiftBloc>(context);
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Registro de Turno"),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                    ),
                  ),
                  body: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(height: 20,),
                        Align(
                            alignment: Alignment.center,
                            child: getStartWidget(state, context, bloc)
                        ),
                        if (state.displayEndDateTimeLine)
                          Align(
                              alignment: Alignment.center,
                              child: Text("↓", style: TextStyle(fontSize: 40))
                          ),
                        if (state.displayEndDateTimeLine)
                          Align(
                              alignment: Alignment.center,
                              child: getEndWidget(state, context, bloc)
                          ),
                        if (state.datesSet)
                          Align(
                              alignment: Alignment.center,
                              child: Text("=", style: TextStyle(fontSize: 32))
                          ),
                        if (state.datesSet)
                          Container(
                              margin: EdgeInsets.all(4),
                              child: Text(
                                "${state.hours} Horas",
                                style: TextStyle(fontSize: 40,
                                    color: Colors.green),
                              )
                          ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  children: [
                                    ElevatedButton(

                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(Colors.green)),
                                      onPressed: !state.isValid
                                          ? null
                                          : () async {
                                        await bloc.save();
                                        Navigator.pop(context, null);
                                      },
                                      child: Text('GUARDAR',
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(Colors.red)),
                                      onPressed: true ? null : () async {


                                      },
                                      child: Text('BORRAR',
                                          style: TextStyle(fontSize: 18)),
                                    ),

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
      );
  }

  Widget getEndWidget(RegisterUnpaidShiftLoadedState state, BuildContext context, RegisterUnpaidShiftBloc bloc)  {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
                      onPressed: () async{
                        final dateResult = await showDatePicker(
                          locale: Locale("es","CO"),
                          context: context,
                          helpText: 'FECHA DE SALIDA',
                          cancelText: "CANCELAR",
                          confirmText: 'SIGUIENTE',
                          firstDate: DateTime(2020),
                          initialDate: state.suggestedEnd.fromLocalToColombianTime(),
                          lastDate: DateTime(2040),
                        );
                        if (dateResult!=null) {
                          final timeResult = await showTimePicker(
                            context: context,
                            helpText: 'HORA DE SALIDA',
                            cancelText: 'CANCELAR',
                            confirmText: 'CONFIRMAR',
                            initialTime: state.suggestedEnd.fromLocalToColombianTime()
                                .timeOfDay(),
                          );
                          if (timeResult!=null){
                            final endDateTime = dateResult.combine(timeValue: timeResult);
                            bloc.add(EndDateTimeEvent(endDateTime));
                          }
                        }
                      },
                      child: Text(state.endDateTimeSet?state.end!.fromLocalToColombianTime()
        .formatDateTime()
        .toCapitalized(): 'FECHA Y HORA DE SALIDA',
                          style: TextStyle(fontSize: 20)),
                    ));
  }

  Widget getStartWidget(RegisterUnpaidShiftLoadedState state, BuildContext context, RegisterUnpaidShiftBloc bloc)  {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
      onPressed: () async{
        final dateResult = await showDatePicker(
          locale: Locale("es","CO"),
          initialEntryMode: DatePickerEntryMode.calendar,
          context: context,
          helpText: 'FECHA DE ENTRADA',
          cancelText: "CANCELAR",
          confirmText: 'SIGUIENTE',
          firstDate: DateTime(2020),
          initialDate: (state.start??DateTime.now()).fromLocalToColombianTime(),
          lastDate: DateTime(2040),
        );
        if (dateResult!=null) {
          final timeResult = await showTimePicker(
            context: context,
            helpText: 'HORA DE ENTRADA',
            cancelText: 'CANCELAR',
            confirmText: 'CONFIRMAR',
            initialTime: (state.start ?? DateTime.now()).fromLocalToColombianTime()
                .timeOfDay()
          );
          if (timeResult!=null){
            final startDateTime = dateResult.combine(timeValue: timeResult);
            bloc.add(StartDateTimeEvent(startDateTime));
          }
        }
      },
      child: Text(state.startDateTimeSet?state.start!.fromLocalToColombianTime()
          .formatDateTime()
          .toCapitalized(): 'FECHA Y HORA DE ENTRADA',
          style: TextStyle(fontSize: 20)),
    ));
  }

}