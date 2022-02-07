import 'package:carerstimelogger/carerstopaylist/CarersToPayDataModel.dart';
import 'package:carerstimelogger/carerstopaylist/CarersToPayRepository.dart';
import 'package:carerstimelogger/carerstopaylist/CarersToPayShiftDataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CarerToPayDetailsEvent.dart';
import 'CarerToPayDetailsState.dart';

class CarerToPayDetailsBloc extends Bloc<CarerToPayDetailsEvent, CarerToPayDetailsState> {
  CarerToPayDetailsBloc() : super(LoadingState()) {
    on<LoadDataEvent>(_onLoadCarer);
    on<PayEvent>(_onPayCarer);
  }

  void _onLoadCarer(
      LoadDataEvent event, Emitter<CarerToPayDetailsState> emit) async {
    emit(LoadingState());
    final carer = await _getCarer(event.carerId);
    emit(LoadedState(carer: carer, saving: false));
  }

  Future<CarerToPayDataModel> _getCarer(String carerId) async {
    final carers = await CarersToPayRepository().getAllCarers();
    List<CarersToPayShiftDataModel> allCarersShifts = List.empty(growable: true);
    for(final carer in carers){
      final unpaidShifts = await CarersToPayRepository().getUnpaidShifts(carerId: carer.id, carerName: carer.nickname);
      final paidShifts = await CarersToPayRepository().getLastPaidShifts(carerId: carer.id, carerName: carer.nickname);
      carer.allUnpaidShifts.addAll(unpaidShifts);
      allCarersShifts.addAll(unpaidShifts);
      allCarersShifts.addAll(paidShifts);
      carer.allUnpaidShifts.sort((a,b) => a.start.compareTo(b.start));
    }
    for(final carerShift in allCarersShifts){
      carerShift.calculateOverlappingShifts(allCarersShifts);
    }
    final carer = carers.firstWhere((element) => element.id==carerId);
    return carer;
  }


  void _onPayCarer(
      PayEvent event, Emitter<CarerToPayDetailsState> emit) async {
    final currentState =  state as LoadedState;

    emit(LoadedState(carer: currentState.carer, saving: true));
    CollectionReference paymentsNode =
    FirebaseFirestore.instance.collection('carers/${currentState.carer.id}/payments');

    await FirebaseFirestore.instance.runTransaction((transaction) async{

      final paymentId = DateTime.now().millisecondsSinceEpoch.toString();
      final paymentDocRef = paymentsNode.doc(paymentId);
      final paymentShiftsCollection = FirebaseFirestore.instance.collection('carers/${currentState.carer.id}/payments/$paymentId/shifts');
      final unpaidCollection = FirebaseFirestore.instance.collection('carers/${currentState.carer.id}/unpaidtime');
       transaction.set(paymentDocRef, {
        'paymentDate': Timestamp.fromDate(DateTime.now()),
        'hours': currentState.carer.hours,
        'rate': currentState.carer.rate,
        'totalPaid': currentState.carer.rate * currentState.carer.hours
      });
       for(final shift in currentState.carer.allUnpaidShifts){
         final shiftDocRef = paymentShiftsCollection.doc(shift.id);
         transaction.set(shiftDocRef, {
           'start': Timestamp.fromDate(shift.start),
           'end': Timestamp.fromDate(shift.end),
         });
         final shiftToDeleteDocRef = unpaidCollection.doc(shift.id);
         transaction.delete(shiftToDeleteDocRef);
       }
    });


    emit(LoadingState());
    final carer = await _getCarer(currentState.carer.id);
    emit(LoadedState(carer: carer, saving: false));
  }


}