import 'package:carerstimelogger/CarerData.dart';
import 'package:carerstimelogger/CarersRepository.dart';
import 'package:carerstimelogger/Extensions.dart';
import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsRepository.dart';
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
    final carerInfo = await CarersRepository().getCarerInfo(event.carerId);
    final shifts = await UnpaidShiftsRepository().getUnpaidShifts(event.carerId);
    shifts.sort((a,b) => a.start.compareTo(b.start));
    emit(LoadedState(shifts: shifts, carer: carerInfo));
  }


}
