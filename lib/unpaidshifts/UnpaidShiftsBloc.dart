import 'UnpaidShiftsEvent.dart';
import 'UnpaidShiftsState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnpaidShiftsBloc extends Bloc<UnpaidShiftsEvent,UnpaidShiftsState> {
  UnpaidShiftsBloc() : super(Loading()){
    on<LoadDataEvent>((event,emit) => emit(state));
  }


}