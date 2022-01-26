import 'package:cloud_firestore/cloud_firestore.dart';

import 'CarersToPayDataModel.dart';

class CarersToPayRepository{
  Future<List<CarerToPayDataModel>> getAllCarers() async{
    final carerUnpaidTime =  FirebaseFirestore.instance.collection('carers');
    final snapshot = await carerUnpaidTime.get();
    final carers = snapshot.docs
        .map((doc) => CarerToPayDataModel(id:doc.id, nickname: doc['nickname']!, usualStartHour: doc['usualStartHour'])
    )
        .toList();
    return carers;
  }
}