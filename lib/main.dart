import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

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
                            child: Text("Total Horas Trabajadas: 14",style: TextStyle(fontSize: 20)),
                          ),
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
