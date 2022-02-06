import 'package:carerstimelogger/carertopaydetails/CarerToPayDetailsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'CarersToPayListBloc.dart';
import 'CarersToPayListEvent.dart';
import 'CarersToPayListState.dart';

class CarersToPayListWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarersToPayListBloc()..add(LoadDataEvent()),
      child: BlocBuilder<CarersToPayListBloc, CarersToPayListState>(
          builder: (context, state) {
            final bloc = BlocProvider.of<CarersToPayListBloc>(context);
            if (state is LoadedState) {
              final carers = state.carers;
              return Scaffold(
                appBar: AppBar(
                    title: Text("Turnos por pagar"),
                    actions: [
                      IconButton(
                          icon: Icon( Icons.sync_outlined, color: Colors.white),
                          onPressed: () async{
                            bloc.add(LoadDataEvent());
                          }),
                    ]
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
                              itemCount: carers.length,
                              itemBuilder: (BuildContext context, int index) {
                                final carer = carers[index];
                                return InkWell(
                                    onTap: () {
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
                                                      carer.nickname,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                    ),
                                                    Container(height: 10,),
                                                    Text(
                                                      "${carer.hours} h x ${NumberFormat.currency(symbol: '\$',decimalDigits: 0).format(carer.rate)}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                    if (carer.isOverlapping)
                                                      Text(
                                                        "** ${carer.overlappedHours} horas cruzadas **",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14),
                                                      ),
                                                  ]),

                                              Expanded(
                                                  child: Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            "${NumberFormat.currency(symbol: '\$',decimalDigits: 0).format(carer.totalToPay)}",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 22),
                                                          ),
                                                        ],
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
                              SizedBox(
                                width: double.infinity,
                                // height: double.infinity,
                                child: Container(
                                  color: Colors.black87,
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      Text(
                                          "TOTAL HORAS TRABAJADAS: ${state.totalHours}",
                                          style: TextStyle(fontSize: 20, color: Colors.white)),
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