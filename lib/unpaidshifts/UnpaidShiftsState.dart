import 'package:carerstimelogger/CarerData.dart';
import 'package:carerstimelogger/unpaidshifts/ShiftDataModel.dart';

abstract class UnpaidShiftsState {}
class LoadingState extends UnpaidShiftsState{}
class LoadedState extends UnpaidShiftsState{
  final List<ShiftDataModel> shifts;
  final CarerData carer;

  double get totalHours => shifts.fold(0, (sum, next) => sum + next.hours);

  LoadedState({required this.shifts , required this.carer});
}