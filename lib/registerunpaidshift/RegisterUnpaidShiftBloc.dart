import 'package:carerstimelogger/CarersRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carerstimelogger/Extensions.dart';
import 'RegisterUnpaidShiftEvent.dart';
import 'RegisterUnpaidShiftState.dart';

class RegisterUnpaidShiftBloc extends Bloc<RegisterUnpaidShiftEvent, RegisterUnpaidShiftState> {
  RegisterUnpaidShiftBloc() : super(LoadingState()) {
    on<NewShiftEvent>(_init);
    on<StartDateTimeEvent>((event,emit)=> emit(RegisterUnpaidShiftLoadedState(carer: (state as RegisterUnpaidShiftLoadedState).carer, carerId: (state as RegisterUnpaidShiftLoadedState).carerId,saving: false, start: event.value.fromColombianToLocalTime(), end: (state as RegisterUnpaidShiftLoadedState).end)));
    on<EndDateTimeEvent>((event,emit)=> emit(RegisterUnpaidShiftLoadedState(carer: (state as RegisterUnpaidShiftLoadedState).carer, carerId: (state as RegisterUnpaidShiftLoadedState).carerId,saving: false, start: (state as RegisterUnpaidShiftLoadedState).start, end: event.value.fromColombianToLocalTime())));
    on<SaveEvent>(_save);
  }


  void _init(NewShiftEvent event, Emitter<RegisterUnpaidShiftState> emit) async{
    emit(LoadingState());
    final repo = CarersRepository();
    final carer = await repo.getCarerInfo(event.carerId);
    emit(RegisterUnpaidShiftLoadedState(carerId: event.carerId,carer: carer, saving: false,  start: null, end: null));
  }

  void _save(SaveEvent event, Emitter<RegisterUnpaidShiftState> emit) async{
    final currentState = state as RegisterUnpaidShiftLoadedState;
    CollectionReference carerUnpaidTime =
    FirebaseFirestore.instance.collection('carers/${currentState.carerId}/unpaidtime');
    emit(RegisterUnpaidShiftLoadedState(carer: currentState.carer, carerId: currentState.carerId, saving: true, start: currentState.start,end: currentState.end));
    final result = await carerUnpaidTime.add({
      'start':Timestamp.fromDate(currentState.start!),
      'end':Timestamp.fromDate(currentState.end!)
    });
    emit(SavedState());
  }

}