import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'RegisterUnpaidShiftEvent.dart';
import 'RegisterUnpaidShiftState.dart';

class RegisterUnpaidShiftBloc extends Bloc<RegisterUnpaidShiftEvent, RegisterUnpaidShiftState> {
  RegisterUnpaidShiftBloc() : super(InitState()) {
    on<NewShiftEvent>((event,emit)=> emit(RegisterUnpaidShiftLoadedState(carerId: event.carerId, start: null, end: null)));
    on<StartDateTimeEvent>((event,emit)=> emit(RegisterUnpaidShiftLoadedState(carerId: (state as RegisterUnpaidShiftLoadedState).carerId, start: event.value, end: (state as RegisterUnpaidShiftLoadedState).end)));
    on<EndDateTimeEvent>((event,emit)=> emit(RegisterUnpaidShiftLoadedState(carerId: (state as RegisterUnpaidShiftLoadedState).carerId, start: (state as RegisterUnpaidShiftLoadedState).start, end: event.value)));
  }

  save() async{
    final currentState = state as RegisterUnpaidShiftLoadedState;
    CollectionReference carerUnpaidTime =
    FirebaseFirestore.instance.collection('carers/${currentState.carerId}/unpaidtime');
    final result = await carerUnpaidTime.add({
      'start':Timestamp.fromDate(currentState.start!),
      'end':Timestamp.fromDate(currentState.end!)
    });

  }

}