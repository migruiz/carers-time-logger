import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../CarersRepository.dart';
import 'CarersListEvent.dart';
import 'CarersListState.dart';

class CarersListBloc extends Bloc<CarersListEvent, CarersListState> {
  CarersListBloc() : super(LoadingState()) {
    on<LoadDataEvent>(_onLoadCarers);
  }


  void _onLoadCarers(
      LoadDataEvent event, Emitter<CarersListState> emit) async {
    emit(LoadingState());
    final carers = await CarersRepository().getAllCarers();
    final allUnpaidshifts = await UnpaidShiftsRepository().getAllUnpaidShifts(carers);

    emit(LoadedState(carers: carers));
  }

}