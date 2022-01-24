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
    CollectionReference carerUnpaidTime =
        FirebaseFirestore.instance.collection('carers/${event.carerId}/unpaidtime');
    final snapshot = await carerUnpaidTime.get();
    final shifts = snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .map((m) => ShiftDataModel(
            start: (m['start'] as Timestamp).toDate(),
            end: (m['end'] as Timestamp).toDate()))
        .toList();
    shifts.sort((a,b) => a.start.compareTo(b.start));
    emit(LoadedState(shifts: shifts));
  }
}
