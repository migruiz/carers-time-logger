import 'package:carerstimelogger/Extensions.dart';
import 'package:carerstimelogger/carerstopaylist/CarersToPayDataModel.dart';
import 'package:carerstimelogger/carerstopaylist/CarersToPayShiftDataModel.dart';
import 'package:flutter/material.dart';

class CarerToPayShiftDetailsWidget extends StatelessWidget{
  final CarerToPayDataModel carer;
  final CarersToPayShiftDataModel shiftData;

  const CarerToPayShiftDetailsWidget({Key? key,required this.carer, required this.shiftData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Turno ${carer.nickname}"),
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
                child: getStartWidget(shiftData)
            ),
              Align(
                  alignment: Alignment.center,
                  child: Text("↓", style: TextStyle(fontSize: 40))
              ),
              Align(
                  alignment: Alignment.center,
                  child: getEndWidget(shiftData)
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text("=", style: TextStyle(fontSize: 32))
              ),
              Container(
                  margin: EdgeInsets.all(4),
                  child: Text(
                    "${shiftData.hours} horas trabajadas",
                    style: TextStyle(fontSize: 32,
                        color: Colors.green),
                  )
              ),
            if (shiftData.isOverlapping)
              Container(height: 10,),
            if (shiftData.isOverlapping)
              Text(
                "** ${shiftData.overlappedHours} horas cruzadas**",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18),
              ),
            if (shiftData.isOverlapping)
          Expanded(
          child:
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(8),
                        shrinkWrap: true,
                        itemCount: shiftData.overlappedShifts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final entry = shiftData.overlappedShifts.entries.toList()[index];
                          final shift = entry.key;
                          final interval = shiftData.getOverlapInterval(shift);
                          final totalOverlapHours = double.parse((entry.value / (1000 * 60 * 60)).toStringAsFixed(1));
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
                                            "** $totalOverlapHours horas cruzadas **",
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
                    )
          ),
          ],
        ),
      ),
    );
  }

  Widget getEndWidget(CarersToPayShiftDataModel shift)  {
    return SizedBox(
        width: double.infinity,
        child: Text(shift.end.fromLocalToColombianTime()
            .formatDateTime()
            .toCapitalized(),
            style: TextStyle(fontSize: 20)));
  }

  Widget getStartWidget(CarersToPayShiftDataModel shift)  {
    return SizedBox(
        width: double.infinity,
        child: Text(shift.start.fromLocalToColombianTime()
            .formatDateTime()
            .toCapitalized(),
            style: TextStyle(fontSize: 20)));
  }

}