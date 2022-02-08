import 'package:carerstimelogger/Extensions.dart';
import 'package:carerstimelogger/carerstopaylist/CarersToPayDataModel.dart';
import 'package:carerstimelogger/carerstopaylist/CarersToPayShiftDataModel.dart';
import 'package:flutter/material.dart';

class CarerToPayShiftDetailsWidget extends StatelessWidget {
  final CarerToPayDataModel carer;
  final CarersToPayShiftDataModel shiftData;

  const CarerToPayShiftDetailsWidget(
      {Key? key, required this.carer, required this.shiftData})
      : super(key: key);

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
            Container(
              height: 20,
            ),
            Align(
                alignment: Alignment.center, child: getStartWidget(shiftData)),
            Align(
                alignment: Alignment.center,
                child: Text("↓", style: TextStyle(fontSize: 40))),
            Align(alignment: Alignment.center, child: getEndWidget(shiftData)),
            Align(
                alignment: Alignment.center,
                child: Text("=", style: TextStyle(fontSize: 32))),
            Container(
                margin: EdgeInsets.all(4),
                child: Text(
                  "${shiftData.hours} horas trabajadas",
                  style: TextStyle(fontSize: 32, color: Colors.green),
                )),
            if (shiftData.isOverlapping)
              Container(
                height: 10,
              ),
            if (shiftData.isOverlapping)
              Text(
                "** ${shiftData.overlappedHours} horas cruzadas**",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            if (shiftData.isOverlapping)
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: shiftData.overlappedShifts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final entry =
                            shiftData.overlappedShifts.entries.toList()[index];
                        final shift = entry.key;
                        final interval = shiftData.getOverlapInterval(shift);
                        final totalOverlapHours = double.parse(
                            (entry.value / (1000 * 60 * 60))
                                .toStringAsFixed(1));
                        return Column(children: [
                          Container(
                            width: double.infinity,
                            color: Colors.redAccent,
                            height: 3,
                          ),
                          Row(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(shiftData.carerName,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18))),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(shift.carerName,
                                          style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 18))))
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.redAccent,
                            child: Align(
                                alignment: interval.entry1.isMe
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Text(
                                    interval.entry1.date
                                        .fromLocalToColombianTime()
                                        .formatDateTime()
                                        .toCapitalized(),
                                    style: TextStyle(
                                        color: interval.entry1.isMe
                                            ? Colors.black
                                            : Colors.deepPurple,
                                        fontSize: 14))),
                          ),
                          Align(
                              alignment: interval.entry2.isMe
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Text(
                                  interval.entry2.date
                                      .fromLocalToColombianTime()
                                      .formatDateTime()
                                      .toCapitalized(),
                                  style: TextStyle(
                                      color: interval.entry2.isMe
                                          ? Colors.black
                                          : Colors.deepPurple,
                                      fontSize: 14))),
                          Align(
                              alignment: interval.entry3.isMe
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Text(
                                  interval.entry3.date
                                      .fromLocalToColombianTime()
                                      .formatDateTime()
                                      .toCapitalized(),
                                  style: TextStyle(
                                      color: interval.entry3.isMe
                                          ? Colors.black
                                          : Colors.deepPurple,
                                      fontSize: 14))),
                          Align(
                              alignment: interval.entry4.isMe
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Text(
                                  interval.entry4.date
                                      .fromLocalToColombianTime()
                                      .formatDateTime()
                                      .toCapitalized(),
                                  style: TextStyle(
                                      color: interval.entry4.isMe
                                          ? Colors.black
                                          : Colors.deepPurple,
                                      fontSize: 14))),
                          Divider(
                            height: 40,
                            thickness: 1,
                          )
                        ]);
                      })),
          ],
        ),
      ),
    );
  }

  Widget getEndWidget(CarersToPayShiftDataModel shift) {
    return SizedBox(
        width: double.infinity,
        child: Text(
            shift.end
                .fromLocalToColombianTime()
                .formatDateTime()
                .toCapitalized(),
            style: TextStyle(fontSize: 20)));
  }

  Widget getStartWidget(CarersToPayShiftDataModel shift) {
    return SizedBox(
        width: double.infinity,
        child: Text(
            shift.start
                .fromLocalToColombianTime()
                .formatDateTime()
                .toCapitalized(),
            style: TextStyle(fontSize: 20)));
  }
}
