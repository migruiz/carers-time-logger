import 'package:carerstimelogger/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'RegisterUnpaidShiftBloc.dart';
import 'RegisterUnpaidShiftEvent.dart';
import 'RegisterUnpaidShiftState.dart';

class RegisterUnpaidShiftWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => RegisterUnpaidShiftBloc()..add(NewShiftEvent()),
        child: BlocBuilder<RegisterUnpaidShiftBloc, RegisterUnpaidShiftState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<RegisterUnpaidShiftBloc>(context);
              return Scaffold(
                appBar: AppBar(
                  title: Text("Registro de Turno"),
                ),
                body: Column(
                  children: [
                    state.startDateTimeSet?Text(
                      state.start!
                          .formatDateTime()
                          .toCapitalized(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16),
                    ):ElevatedButton(
                      onPressed: () async{
                        final dateResult = await showDatePicker(
                          initialEntryMode: DatePickerEntryMode.calendar,
                          context: context,
                          helpText: 'FECHA DE ENTRADA',
                          cancelText: "CANCELAR",
                          confirmText: 'SIGUIENTE',
                          firstDate: DateTime(2020),
                          initialDate: state.start??DateTime.now(),
                          lastDate: DateTime(2040),
                        );
                        if (dateResult!=null) {
                          final timeResult = await showTimePicker(
                            context: context,
                            helpText: 'HORA DE ENTRADA',
                            cancelText: 'CANCELAR',
                            confirmText: 'CONFIRMAR',
                            initialTime: (state.start ?? DateTime.now())
                                .timeOfDay(),
                          );
                          if (timeResult!=null){
                            final startDateTime = dateResult.combine(timeValue: timeResult);
                            bloc.add(StartDateTimeEvent(startDateTime));
                          }
                        }
                      },
                      child: Text('Fecha y Hora de Entrada',
                          style: TextStyle(fontSize: 18)),
                    ),
                    if (state.displayEndDateTimeLine)
                      state.endDateTimeSet?Text(
                        state.end!
                            .formatDateTime()
                            .toCapitalized(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16),
                      ):ElevatedButton(
                        onPressed: () async{
                          final dateResult = await showDatePicker(
                            context: context,
                            helpText: 'FECHA DE SALIDA',
                            cancelText: "CANCELAR",
                            confirmText: 'SIGUIENTE',
                            firstDate: DateTime(2020),
                            initialDate: state.end??DateTime.now(),
                            lastDate: DateTime(2040),
                          );
                          if (dateResult!=null) {
                            final timeResult = await showTimePicker(
                              context: context,
                              helpText: 'HORA DE SALIDA',
                              cancelText: 'CANCELAR',
                              confirmText: 'CONFIRMAR',
                              initialTime: (state.end ?? DateTime.now())
                                  .timeOfDay(),
                            );
                            if (timeResult!=null){
                              final endDateTime = dateResult.combine(timeValue: timeResult);
                              bloc.add(EndDateTimeEvent(endDateTime));
                            }
                          }
                        },
                        child: Text('Fecha y Hora de Salida',
                            style: TextStyle(fontSize: 18)),
                      )
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

}