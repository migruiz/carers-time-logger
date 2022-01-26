import 'package:carerstimelogger/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'CarerToPayDetailsBloc.dart';
import 'CarerToPayDetailsEvent.dart';
import 'CarerToPayDetailsState.dart';

class CarerToPayDetailsWidget extends StatelessWidget{
  final String carerId;

  const CarerToPayDetailsWidget({Key? key, required this.carerId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarerToPayDetailsBloc()..add(LoadDataEvent(carerId: carerId)),
      child: BlocBuilder<CarerToPayDetailsBloc, CarerToPayDetailsState>(
          builder: (context, state) {
            final bloc = BlocProvider.of<CarerToPayDetailsBloc>(context);
            if (state is LoadedState) {
              final carer = state.carer;
              final shifts = carer.allUnpaidShifts;
              return Scaffold(
                appBar: AppBar(
                  title: Text("${shifts.length} Turnos por pagar de ${state.carer.nickname}"),
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

                                      bloc.add(LoadDataEvent(carerId: this.carerId));
                                    },
                                    child: Column(
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
                                                  ]),

                                              Expanded(
                                                  child: Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            "${shift.hours}h",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 22),
                                                          ),
                                                        ],
                                                      )))
                                            ],
                                          ),
                                          if (shift.isOverlapping)
                                            Text(
                                              "** ${shift.overlappedHours} horas cruzadas **",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
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
                                  child: Column(
                                    children: [
                                      Text(
                                          "TOTAL HORAS TRABAJADAS: ${carer.hours.toStringAsFixed(1)}",
                                          style: TextStyle(fontSize: 20, color: Colors.white)),
                                      if (carer.isOverlapping)
                                        Text(
                                            "** HORAS CRUZADAS: ${carer.overlappedHours.toStringAsFixed(1)} **",
                                            style: TextStyle(fontSize: 16, color: Colors.redAccent))
                                    ],
                                  ),
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
    );
  }

}