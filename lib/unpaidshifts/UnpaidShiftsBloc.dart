import 'package:carerstimelogger/CarerData.dart';
import 'package:carerstimelogger/CarersRepository.dart';
import 'package:carerstimelogger/Extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ShiftDataModel.dart';
import 'UnpaidShiftsEvent.dart';
import 'UnpaidShiftsState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnpaidShiftsBloc extends Bloc<UnpaidShiftsEvent, UnpaidShiftsState> {
  UnpaidShiftsBloc() : super(LoadingState()) {
    on<LoadDataEvent>(_onLoadShifts);
  }

  void _onLoadShifts(
      LoadDataEvent event, Emitter<UnpaidShiftsState> emit) async {
    emit(LoadingState());
    final carerUnpaidTime =  FirebaseFirestore.instance.collection('carers/${event.carerId}/unpaidtime');
    final carersRepo = CarersRepository();
    CarerData carerInfo = await carersRepo.getCarerInfo(event.carerId);
    final snapshot = await carerUnpaidTime.get();
    final shifts = snapshot.docs
        .map((doc) => doc.data())
        .map((m) => ShiftDataModel(
            start: (m['start'] as Timestamp).toDate(),
            end: (m['end'] as Timestamp).toDate()
        ))
        .toList();
    shifts.sort((a,b) => a.start.compareTo(b.start));
    emit(LoadedState(shifts: shifts, carer: carerInfo));
  }


}
