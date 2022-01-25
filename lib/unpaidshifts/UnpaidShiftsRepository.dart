import 'package:carerstimelogger/CarersRepository.dart';
import 'package:carerstimelogger/unpaidshifts/ShiftDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UnpaidShiftsRepository{
  Future<List<ShiftDataModel>> getUnpaidShifts({required String carerId, required String carerName}) async{
    final carerUnpaidTime =  FirebaseFirestore.instance.collection('carers/$carerId/unpaidtime');
    final snapshot = await carerUnpaidTime.get();
    final shifts = snapshot.docs
        .map((doc) => ShiftDataModel(
        id: doc.id,
        carerName: carerName,
        start: (doc.data()['start'] as Timestamp).toDate(),
        end: (doc.data()['end'] as Timestamp).toDate()
    ))
        .toList();
    return shifts;
  }




  Future<List<ShiftDataModel>> getAllUnpaidShifts() async{
    final carers = await CarersRepository().getAllCarers();
    List<ShiftDataModel> list = List.empty(growable: true);
    for(final carer in carers){
        final unpaidShifts = await getUnpaidShifts(carerId: carer.id, carerName: carer.nickname);
        list.addAll(unpaidShifts);
    }
    return list;

  }

}