import 'package:carerstimelogger/carerstopaylist/CarersToPayRepository.dart';
import 'package:carerstimelogger/carerstopaylist/CarersToPayShiftDataModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CarerToPayDetailsEvent.dart';
import 'CarerToPayDetailsState.dart';

class CarerToPayDetailsBloc extends Bloc<CarerToPayDetailsEvent, CarerToPayDetailsState> {
  CarerToPayDetailsBloc() : super(LoadingState()) {
    on<LoadDataEvent>(_onLoadCarer);
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
    }
    for(final unpaidShift in allUnpaidShifts){
      unpaidShift.calculateOverlappingShifts(allUnpaidShifts);
    }
    final carer = carers.firstWhere((element) => element.id==event.carerId);
    emit(LoadedState(carer: carer));
  }

}