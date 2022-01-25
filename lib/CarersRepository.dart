import 'package:carerstimelogger/CarerShiftData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'CarerData.dart';

class CarersRepository{
  Future<CarerData> getCarerInfo(String carerId) async {
    final carerDataCollection =  FirebaseFirestore.instance.collection('carers');
    final carerInfoSnaphost = await carerDataCollection.doc(carerId).get();
    final carearInfoMap =  carerInfoSnaphost.data() as Map<String, dynamic>;
    final carerInfo = CarerData(nickname: carearInfoMap['nickname']!, usualStartHour: carearInfoMap['usualStartHour']);
    return carerInfo;
  }


}