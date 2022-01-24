import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carerstimelogger/Extensions.dart';
import 'RegisterUnpaidShiftEvent.dart';
import 'RegisterUnpaidShiftState.dart';

class RegisterUnpaidShiftBloc extends Bloc<RegisterUnpaidShiftEvent, RegisterUnpaidShiftState> {
  RegisterUnpaidShiftBloc() : super(InitState()) {
    on<NewShiftEvent>((event,emit)=> emit(RegisterUnpaidShiftLoadedState(carerId: event.carerId,saving: false,  start: null, end: null)));
    on<StartDateTimeEvent>((event,emit)=> emit(RegisterUnpaidShiftLoadedState(carerId: (state as RegisterUnpaidShiftLoadedState).carerId,saving: false, start: event.value.fromColombianToLocalTime(), end: (state as RegisterUnpaidShiftLoadedState).end)));
    on<EndDateTimeEvent>((event,emit)=> emit(RegisterUnpaidShiftLoadedState(carerId: (state as RegisterUnpaidShiftLoadedState).carerId,saving: false, start: (state as RegisterUnpaidShiftLoadedState).start, end: event.value.fromColombianToLocalTime())));
    on<SaveEvent>(_save);
  }

  void _save(SaveEvent event, Emitter<RegisterUnpaidShiftState> emit) async{
    final currentState = state as RegisterUnpaidShiftLoadedState;
    CollectionReference carerUnpaidTime =
    FirebaseFirestore.instance.collection('carers/${currentState.carerId}/unpaidtime');
    emit(RegisterUnpaidShiftLoadedState(carerId: currentState.carerId, saving: true, start: currentState.start,end: currentState.end));
    final result = await carerUnpaidTime.add({
      'start':Timestamp.fromDate(currentState.start!),
      'end':Timestamp.fromDate(currentState.end!)
    });
    emit(SavedState());
  }

}