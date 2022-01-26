import 'package:flutter_bloc/flutter_bloc.dart';

import 'CarerToPayDetailsEvent.dart';
import 'CarerToPayDetailsState.dart';

class CarerToPayDetailsBloc extends Bloc<CarerToPayDetailsEvent, CarerToPayDetailsState> {
  CarerToPayDetailsBloc() : super(LoadingState()) {
    //on<CarerToPayDetailsEvent>(_onLoadShifts);
  }
}