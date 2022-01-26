import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../CarersRepository.dart';
import 'CarersToPayListEvent.dart';
import 'CarersToPayListState.dart';
import 'CarersToPayRepository.dart';

class CarersToPayListBloc extends Bloc<CarersToPayListEvent, CarersToPayListState> {
  CarersToPayListBloc() : super(LoadingState()) {
    on<LoadDataEvent>(_onLoadCarers);
  }


  void _onLoadCarers(
      LoadDataEvent event, Emitter<CarersToPayListState> emit) async {
    emit(LoadingState());
    final carers = await CarersToPayRepository().getAllCarers();
    emit(LoadedState(carers: carers));
  }

}