import 'package:cloud_firestore/cloud_firestore.dart';

import 'CarerData.dart';

class CarersRepository{
  Future<CarerData> getCarerInfo(String carerId) async {
    final carerDataCollection =  FirebaseFirestore.instance.collection('carers');
    final carerInfoSnaphost = await carerDataCollection.doc(carerId).get();
    final carearInfoMap =  carerInfoSnaphost.data() as Map<String, dynamic>;
    final carerInfo = CarerData(id: carerInfoSnaphost.id, nickname: carearInfoMap['nickname']!, usualStartHour: carearInfoMap['usualStartHour']);
    return carerInfo;
  }
  Future<List<CarerData>> getAllCarers() async{
    final carerUnpaidTime =  FirebaseFirestore.instance.collection('carers');
    final snapshot = await carerUnpaidTime.get();
    final carers = snapshot.docs
        .map((doc) => CarerData(id:doc.id, nickname: doc['nickname']!, usualStartHour: doc['usualStartHour'])
    )
        .toList();
    return carers;
  }

}