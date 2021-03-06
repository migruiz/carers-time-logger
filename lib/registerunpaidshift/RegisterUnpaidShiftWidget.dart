import 'package:carerstimelogger/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'RegisterUnpaidShiftBloc.dart';
import 'RegisterUnpaidShiftEvent.dart';
import 'RegisterUnpaidShiftState.dart';

class RegisterUnpaidShiftWidget extends StatelessWidget{
  final String carerId;
  final String? shiftId;

  const RegisterUnpaidShiftWidget({Key? key,required this.carerId, required this.shiftId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (_) => RegisterUnpaidShiftBloc()..add(this.shiftId==null?NewShiftEvent(carerId: carerId):EditShiftEvent(carerId: carerId, shiftId: shiftId!)),
        child: BlocBuilder<RegisterUnpaidShiftBloc, RegisterUnpaidShiftState>(
            builder: (context, state) {
              if (state is RegisterUnpaidShiftLoadedState) {
                final bloc = BlocProvider.of<RegisterUnpaidShiftBloc>(context);
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Registro de Turno ${state.carer.nickname}"),
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
                                "${state.hours} horas trabajadas",
                                style: TextStyle(fontSize: 32,
                                    color: Colors.green),
                              )
                          ),
                        if (state.isOverlapping)
                          Container(height: 10,),
                        if (state.isOverlapping)
                          Text(
                            "** ${state.totalOverlappedHours} horas cruzadas**",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18),
                          ),
                        if (state.isOverlapping)
              Expanded(
              child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.all(8),
                              shrinkWrap: true,
                              itemCount: state.overlappedShifts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final entry = state.overlappedShifts.entries.toList()[index];
                                final shift = entry.key;
                                final totalOverlap = entry.value;
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  shift.carerName,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  shift.start
                                                      .fromLocalToColombianTime()
                                                      .formatDateTime()
                                                      .toCapitalized(),
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(left:20),
                                                    child:Text("↓",style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 20))),
                                                Text(
                                                  shift.end
                                                      .fromLocalToColombianTime()
                                                      .formatDateTime()
                                                      .toCapitalized(),
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  "** $totalOverlap horas cruzadas **",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red,
                                                      fontSize: 14),
                                                ),
                                              ]),


                                        ],
                                      ),
                                      Divider(
                                        height: 40,
                                        thickness: 1,
                                      )
                                    ]);
                              }
                          )),
                        Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                   if (state.isValid)
                                     ElevatedButton(

                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(Colors.green)),
                                      onPressed:state.saving?null: ()  {
                                        bloc.add(SaveEvent());
                                      },
                                      child: Text(state.saving?'GUARDANDO...':'GUARDAR',
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                    if (state.isValid && !state.isNew) Spacer(),
                                    if (state.isValid && !state.isNew)
                                      ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(Colors.red)),
                                      onPressed: state.saving?null: ()  async{
                                        if (await context.confirmOperationWithDialog("Confirmar Borrar Turno?")) {
                                          bloc.add(DeleteEvent());
                                        }

                                      },
                                      child: Text(state.saving?'BORRANDO...':'BORRAR',
                                          style: TextStyle(fontSize: 18)),
                                    ),

                                  ],
                                )))
                      ],
                    ),
                  ),
                );
              }
              else if (state is SavedState){
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pop(context, true);
                });
                return Scaffold(
                    appBar: AppBar(
                      title: Text("Registro de Turno"),
                    ),
                    body:Center(
                      child: Container(),
                    )
                );
              }
              else if (state is LoadingState){
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Registro de Turno"),
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
                              builder: (context, child) {
                                if (MediaQuery.of(context).alwaysUse24HourFormat) {
                                  return child!;
                                } else {
                                  return Localizations.override(
                                    context: context,
                                    locale: Locale('en', 'US'),
                                    child: child,
                                  );
                                }
                              });
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
          initialDate: state.suggestedStart.fromLocalToColombianTime(),
          lastDate: DateTime(2040),
        );
        if (dateResult!=null) {
          final timeResult = await showTimePicker(
            context: context,
            helpText: 'HORA DE ENTRADA',
            cancelText: 'CANCELAR',
            confirmText: 'CONFIRMAR',
            initialTime: state.suggestedStart.fromLocalToColombianTime()
                .timeOfDay(),
              builder: (context, child) {
                if (MediaQuery.of(context).alwaysUse24HourFormat) {
                  return child!;
                } else {
                  return Localizations.override(
                    context: context,
                    locale: Locale('en', 'US'),
                    child: child,
                  );
                }
              }
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