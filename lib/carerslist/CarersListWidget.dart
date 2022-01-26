import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'CarersListBloc.dart';
import 'CarersListEvent.dart';
import 'CarersListState.dart';

class CarersListWidget extends StatelessWidget{

  const CarersListWidget({Key? key}) : super(key: key);
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
        create: (_) => CarersListBloc()..add(LoadDataEvent()),
        child: BlocBuilder<CarersListBloc, CarersListState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<CarersListBloc>(context);
              if (state is LoadedState) {
                final carers = state.carers;
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Turnos por pagar"),
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
                                      onTap: () async{
                                        bloc.add(LoadDataEvent());
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
                                                              "TOTh",
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
                                            "TOTAL HORAS TRABAJADAS: }",
                                            style: TextStyle(fontSize: 20, color: Colors.white)),
                                          Text(
                                              "** HORAS CRUZADAS: **",
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
      ),
    );
  }

}