import 'package:carerstimelogger/unpaidshifts/ShiftDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UnpaidShiftsRepository{
  Future<List<ShiftDataModel>> getUnpaidShifts(String carerId) async{
    final carerUnpaidTime =  FirebaseFirestore.instance.collection('carers/$carerId/unpaidtime');
    final snapshot = await carerUnpaidTime.get();
    final shifts = snapshot.docs
        .map((doc) => ShiftDataModel(
        id: doc.id,
        start: (doc.data()['start'] as Timestamp).toDate(),
        end: (doc.data()['end'] as Timestamp).toDate()
    ))
        .toList();
    return shifts;
  }
}