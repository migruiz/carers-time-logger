
import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../CarersRepository.dart';
import 'CarersToPayListEvent.dart';
import 'CarersToPayListState.dart';
import 'CarersToPayRepository.dart';
import 'CarersToPayShiftDataModel.dart';

class CarersToPayListBloc extends Bloc<CarersToPayListEvent, CarersToPayListState> {
  CarersToPayListBloc() : super(LoadingState()) {
    on<LoadDataEvent>(_onLoadCarers);
  }


  void _onLoadCarers(
      LoadDataEvent event, Emitter<CarersToPayListState> emit) async {
    emit(LoadingState());
    final carers = await CarersToPayRepository().getAllCarers();
    List<CarersToPayShiftDataModel> allCarersShifts = List.empty(growable: true);
    for(final carer in carers){
      final unpaidShifts = await CarersToPayRepository().getUnpaidShifts(carerId: carer.id, carerName: carer.nickname);
      final paidShifts = await CarersToPayRepository().getLastPaidShifts(carerId: carer.id, carerName: carer.nickname);
      carer.allUnpaidShifts.addAll(unpaidShifts);
      allCarersShifts.addAll(unpaidShifts);
      allCarersShifts.addAll(paidShifts);
    }
    for(final carerShift in allCarersShifts){
      carerShift.calculateOverlappingShifts(allCarersShifts);
    }
    emit(LoadedState(carers: carers));
  }

}