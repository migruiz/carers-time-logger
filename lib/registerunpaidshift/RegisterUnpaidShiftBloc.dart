import 'package:flutter_bloc/flutter_bloc.dart';

import 'RegisterUnpaidShiftEvent.dart';
import 'RegisterUnpaidShiftState.dart';

class UnpaidShiftsBloc extends Bloc<RegisterUnpaidShiftEvent, RegisterUnpaidShiftState> {
  UnpaidShiftsBloc() : super(RegisterUnpaidShiftState(start: null, end: null)) {
    on<NewShiftEvent>((event,emit)=> emit(RegisterUnpaidShiftState(start: null, end: null)));
    on<StartDateTimeEvent>((event,emit)=> emit(RegisterUnpaidShiftState(start: event.value, end: state.end)));
    on<EndDateTimeEvent>((event,emit)=> emit(RegisterUnpaidShiftState(start: state.start, end: event.value)));
  }


}