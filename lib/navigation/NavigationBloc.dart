import 'package:carerstimelogger/navigation/NavigationEvent.dart';
import 'package:carerstimelogger/navigation/NavigationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(RouteNotFoundState()){
    on<NotFoundRouteEvent>(_onNotFoundRouteEvent);
    on<PayShiftsEvent>(_onPayShiftsEvent);
    on<PayShiftsDetailsEvent>(_onPayShiftsDetailsEvent);
  }


  void _onNotFoundRouteEvent(
      NotFoundRouteEvent event, Emitter<NavigationState> emit) async {
          emit(RouteNotFoundState());
  }
  void _onPayShiftsEvent(
      PayShiftsEvent event, Emitter<NavigationState> emit) async {
    emit(PayShiftsState());
  }
  void _onPayShiftsDetailsEvent(
      PayShiftsDetailsEvent event, Emitter<NavigationState> emit) async {
    emit(PayShiftsDetailsState(event.carerId));
  }

}
