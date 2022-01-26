import 'package:cloud_firestore/cloud_firestore.dart';

import '../ShiftDataModel.dart';
import 'CarersToPayDataModel.dart';
import 'CarersToPayShiftDataModel.dart';

class CarersToPayRepository{
  Future<List<CarerToPayDataModel>> getAllCarers() async{
    final carerUnpaidTime =  FirebaseFirestore.instance.collection('carers');
    final snapshot = await carerUnpaidTime.get();
    final carers = snapshot.docs
        .map((doc) => CarerToPayDataModel(
        id:doc.id,
        nickname: doc['nickname']!,
        usualStartHour: doc['usualStartHour'],
        rate: doc['rate']
    )
    )
        .toList();
    return carers;
  }
  Future<List<CarersToPayShiftDataModel>> getUnpaidShifts( String carerId) async{
    final carerUnpaidTime =  FirebaseFirestore.instance.collection('carers/$carerId/unpaidtime');
    final snapshot = await carerUnpaidTime.get();
    final shifts = snapshot.docs
        .map((doc) => CarersToPayShiftDataModel(
        id: doc.id,
        start: (doc.data()['start'] as Timestamp).toDate(),
        end: (doc.data()['end'] as Timestamp).toDate()
    ))
        .toList();
    return shifts;
  }
}