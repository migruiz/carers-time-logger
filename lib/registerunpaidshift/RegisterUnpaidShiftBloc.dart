import 'package:carerstimelogger/CarersRepository.dart';
import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carerstimelogger/Extensions.dart';
import 'RegisterUnpaidShiftEvent.dart';
import 'RegisterUnpaidShiftState.dart';

class RegisterUnpaidShiftBloc extends Bloc<RegisterUnpaidShiftEvent, RegisterUnpaidShiftState> {
  RegisterUnpaidShiftLoadedState get currentState  => state as RegisterUnpaidShiftLoadedState;
  RegisterUnpaidShiftBloc() : super(LoadingState()) {
    on<NewShiftEvent>(_onNewShift);
    on<EditShiftEvent>(_onEditShift);
    on<StartDateTimeEvent>((event,emit)=> emit(
          RegisterUnpaidShiftLoadedState(
              shiftId: currentState.shiftId,
              carer: currentState.carer,
              carerId: currentState.carerId,
              allUnpaidShifts: currentState.allUnpaidShifts,
              saving: false,
              start: event.value.fromColombianToLocalTime(),
              end: currentState.end
    )
            ..calculateOverlappingShifts()
    ));
    on<EndDateTimeEvent>((event,emit)=> emit(
        RegisterUnpaidShiftLoadedState(
            shiftId: currentState.shiftId,
            carer: currentState.carer,
            carerId: currentState.carerId,
            allUnpaidShifts: currentState.allUnpaidShifts,
            saving: false,
            start: currentState.start,
            end: event.value.fromColombianToLocalTime()
        )
          ..calculateOverlappingShifts()
    ));
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  void _onEditShift(EditShiftEvent event, Emitter<RegisterUnpaidShiftState> emit) async{
    emit(LoadingState());
    final repo = CarersRepository();
    final carer = await repo.getCarerInfo(event.carerId);
    final allUnpaidshifts = await UnpaidShiftsRepository().getAllUnpaidShifts();
    final unpaidShiftsCollection =  FirebaseFirestore.instance.collection('carers/${event.carerId}/unpaidtime');
    final shiftInfoSnaphost = await unpaidShiftsCollection.doc(event.shiftId).get();
    final shiftInfoMap =  shiftInfoSnaphost.data() as Map<String, dynamic>;

    emit(RegisterUnpaidShiftLoadedState(
        carerId: event.carerId,
        carer: carer,
        shiftId: event.shiftId,
        saving: false,
        allUnpaidShifts: allUnpaidshifts,
        start: (shiftInfoMap['start'] as Timestamp).toDate(),
        end: (shiftInfoMap['end'] as Timestamp).toDate()
    )..calculateOverlappingShifts()
    );
  }

  void _onNewShift(NewShiftEvent event, Emitter<RegisterUnpaidShiftState> emit) async{
    emit(LoadingState());
    final repo = CarersRepository();
    final carer = await repo.getCarerInfo(event.carerId);
    final allUnpaidshifts = await UnpaidShiftsRepository().getAllUnpaidShifts();
    emit(RegisterUnpaidShiftLoadedState(
        carerId: event.carerId,
        shiftId:null,
        carer: carer,
        saving: false,
        allUnpaidShifts: allUnpaidshifts,
        start: null,
        end: null
    )..calculateOverlappingShifts()
    );
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<RegisterUnpaidShiftState> emit) async{
    CollectionReference carerUnpaidTime =
    FirebaseFirestore.instance.collection('carers/${currentState.carerId}/unpaidtime');
    emit(RegisterUnpaidShiftLoadedState(
        carer: currentState.carer,
        shiftId: currentState.shiftId,
        carerId: currentState.carerId,
        saving: true,
        allUnpaidShifts: currentState.allUnpaidShifts,
        start: currentState.start,
        end: currentState.end
    )..calculateOverlappingShifts()
    );
    await carerUnpaidTime.doc(currentState.shiftId).delete();
    emit(SavedState());
  }

  void _onSaveEvent(SaveEvent event, Emitter<RegisterUnpaidShiftState> emit) async{
    CollectionReference carerUnpaidTime =
    FirebaseFirestore.instance.collection('carers/${currentState.carerId}/unpaidtime');
    emit(RegisterUnpaidShiftLoadedState(
        carer: currentState.carer,
        shiftId: currentState.shiftId,
        carerId: currentState.carerId,
        saving: true,
        allUnpaidShifts: currentState.allUnpaidShifts,
        start: currentState.start,
        end: currentState.end
    )..calculateOverlappingShifts()
    );
    if (currentState.isNew) {
      await carerUnpaidTime.add({
        'start': Timestamp.fromDate(currentState.start!),
        'end': Timestamp.fromDate(currentState.end!)
      });
    }
    else{
      await carerUnpaidTime.doc(currentState.shiftId).set({
        'start': Timestamp.fromDate(currentState.start!),
        'end': Timestamp.fromDate(currentState.end!)
      });
    }
    emit(SavedState());
  }

}