import 'package:carerstimelogger/CarersRepository.dart';
import 'package:carerstimelogger/ShiftDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'MyShiftDataModel.dart';

class UnpaidShiftsRepository{
  Future<List<MyShiftDataModel>> getUnpaidShifts( String carerId) async{
    final carerUnpaidTime =  FirebaseFirestore.instance.collection('carers/$carerId/unpaidtime');
    final snapshot = await carerUnpaidTime.get();
    final shifts = snapshot.docs
        .map((doc) => MyShiftDataModel(
        id: doc.id,
        start: (doc.data()['start'] as Timestamp).toDate(),
        end: (doc.data()['end'] as Timestamp).toDate()
    ))
        .toList();
    return shifts;
  }

  int calculateOverlap({required DateTime myShiftStart,required  DateTime myShiftEnd,required  DateTime otherShiftStart,required  DateTime otherShiftEnd}) {
    final myShiftInterval = myShiftEnd.millisecondsSinceEpoch - myShiftStart.millisecondsSinceEpoch;
    final otherShiftInterval = otherShiftEnd.millisecondsSinceEpoch - otherShiftStart.millisecondsSinceEpoch;
    if (myShiftEnd.millisecondsSinceEpoch >= otherShiftStart.millisecondsSinceEpoch && myShiftStart.millisecondsSinceEpoch <= otherShiftEnd.millisecondsSinceEpoch){
      final int overlapTime;
      if (myShiftEnd.millisecondsSinceEpoch <= otherShiftEnd.millisecondsSinceEpoch) {
        final delta = myShiftEnd.millisecondsSinceEpoch -
            otherShiftStart.millisecondsSinceEpoch;
        overlapTime = myShiftInterval < delta ? myShiftInterval : delta;
      }
      else{
        final delta = otherShiftEnd.millisecondsSinceEpoch -
            myShiftStart.millisecondsSinceEpoch;
        overlapTime = otherShiftInterval < delta ? otherShiftInterval  : delta;
      }
      return overlapTime;
    }
    return 0;
  }

  Future<List<ShiftDataModel>> getAllUnpaidShifts() async{
    final carers = await CarersRepository().getAllCarers();
    List<ShiftDataModel> list = List.empty(growable: true);
    for(final carer in carers){
        final unpaidShifts = await getUnpaidShifts(carer.id);
        list.addAll(unpaidShifts.map((e) => ShiftDataModel(start: e.start, end: e.end, id: e.id, carerName: carer.nickname)));
    }
    return list;

  }

}