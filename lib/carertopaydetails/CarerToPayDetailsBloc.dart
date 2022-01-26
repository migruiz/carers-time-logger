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
    final carers = await CarersToPayRepository().getAllCarers();
    List<CarersToPayShiftDataModel> allUnpaidShifts = List.empty(growable: true);
    for(final carer in carers){
      final unpaidShifts = await CarersToPayRepository().getUnpaidShifts(carer.id);
      carer.allUnpaidShifts.addAll(unpaidShifts);
      allUnpaidShifts.addAll(unpaidShifts);
      carer.allUnpaidShifts.sort((a,b) => a.start.compareTo(b.start));
    }
    for(final unpaidShift in allUnpaidShifts){
      unpaidShift.calculateOverlappingShifts(allUnpaidShifts);
    }
    final carer = carers.firstWhere((element) => element.id==event.carerId);
    emit(LoadedState(carer: carer));
  }


  void _onPayCarer(
      PayEvent event, Emitter<CarerToPayDetailsState> emit) async {
    final currentState =  state as LoadedState;

    emit(LoadingState());
    CollectionReference paymentsNode =
    FirebaseFirestore.instance.collection('carers/${currentState.carer.id}/payments');

    await FirebaseFirestore.instance.runTransaction((transaction) async{

      final paymentId = DateTime.now().millisecondsSinceEpoch.toString();
      final paymentDocRef = paymentsNode.doc(paymentId);
      final paymentShiftsCollection = FirebaseFirestore.instance.collection('carers/${currentState.carer.id}/payments/$paymentId/shifts');

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
       }
    });


    emit(LoadedState(carer: currentState.carer));
  }


}