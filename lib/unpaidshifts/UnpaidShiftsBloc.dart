import 'package:carerstimelogger/CarerData.dart';
import 'package:carerstimelogger/CarersRepository.dart';
import 'package:carerstimelogger/Extensions.dart';
import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ShiftDataModel.dart';
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
    final carerInfo = await CarersRepository().getCarerInfo(event.carerId);
    final shifts = await UnpaidShiftsRepository().getUnpaidShifts(event.carerId);
    final allOtherShifsts = await UnpaidShiftsRepository().getAllUnpaidShifts();

    for(final myShift in shifts){
      for(final otherShift in allOtherShifsts){
          if (myShift.id!=otherShift.id && myShift.end.millisecondsSinceEpoch >= otherShift.start.millisecondsSinceEpoch && myShift.start.millisecondsSinceEpoch <= otherShift.end.millisecondsSinceEpoch){
            final int overlapTime;
            if (myShift.end.millisecondsSinceEpoch <= otherShift.end.millisecondsSinceEpoch) {
              final delta = myShift.end.millisecondsSinceEpoch -
                  otherShift.start.millisecondsSinceEpoch;
              overlapTime = myShift.interval < delta ? myShift.interval : delta;
            }
            else{
              final delta = otherShift.end.millisecondsSinceEpoch -
                  myShift.start.millisecondsSinceEpoch;
              overlapTime = otherShift.interval < delta ? otherShift.interval  : delta;
            }
            myShift.addOverlappedShift(otherShift,overlapTime);
          }
      }
    }

    shifts.sort((a,b) => a.start.compareTo(b.start));
    emit(LoadedState(shifts: shifts, carer: carerInfo));
  }


}
