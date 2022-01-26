
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
    List<CarersToPayShiftDataModel> allUnpaidShifts = List.empty(growable: true);
    for(final carer in carers){
      final unpaidShifts = await CarersToPayRepository().getUnpaidShifts(carerId: carer.id, carerName: carer.nickname);
      carer.allUnpaidShifts.addAll(unpaidShifts);
      allUnpaidShifts.addAll(unpaidShifts);
    }
    for(final unpaidShift in allUnpaidShifts){
      unpaidShift.calculateOverlappingShifts(allUnpaidShifts);
    }
    emit(LoadedState(carers: carers));
  }

}