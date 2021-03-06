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
  Future<CarerToPayDataModel> getCarer(String carerId) async {
    final carerDataCollection =  FirebaseFirestore.instance.collection('carers');
    final carerInfoSnaphost = await carerDataCollection.doc(carerId).get();
    final carearInfoMap =  carerInfoSnaphost.data() as Map<String, dynamic>;
    final carerInfo = CarerToPayDataModel(
        id: carerInfoSnaphost.id,
        nickname: carearInfoMap['nickname']!,
        usualStartHour: carearInfoMap['usualStartHour'],
        rate: carearInfoMap['rate']
    );
    return carerInfo;
  }


  Future<List<CarersToPayShiftDataModel>> getUnpaidShifts({required String carerId, required String carerName}) async{
    final carerUnpaidTime =  FirebaseFirestore.instance.collection('carers/$carerId/unpaidtime');
    final snapshot = await carerUnpaidTime.get();
    final shifts = snapshot.docs
        .map((doc) => CarersToPayShiftDataModel(
        id: doc.id,
        carerName: carerName,
        start: (doc.data()['start'] as Timestamp).toDate(),
        end: (doc.data()['end'] as Timestamp).toDate()
    ))
        .toList();
    return shifts;
  }
  Future<List<CarersToPayShiftDataModel>> getLastPaidShifts({required String carerId, required String carerName}) async{
    final carerPaymentsCollection =  FirebaseFirestore.instance.collection('carers/$carerId/payments');
    final snapshotcarerPaymentsCollection = await carerPaymentsCollection.get();
    final paymentIds = snapshotcarerPaymentsCollection.docs.map((doc) => doc.id);
    final List<CarersToPayShiftDataModel> paidShiftsTotal = List.empty(growable: true);
    for(final paymentId in paymentIds.toList()) {
      final carerShiftsCollection = FirebaseFirestore.instance.collection('carers/$carerId/payments/$paymentId/shifts');
      final snapshot = await carerShiftsCollection.get();
      final shifts = snapshot.docs
          .map((doc) => CarersToPayShiftDataModel(
          id: doc.id,
          carerName: carerName,
          start: (doc.data()['start'] as Timestamp).toDate(),
          end: (doc.data()['end'] as Timestamp).toDate()
      )).toList();
      paidShiftsTotal.addAll(shifts);
    }
    return paidShiftsTotal;
  }

}