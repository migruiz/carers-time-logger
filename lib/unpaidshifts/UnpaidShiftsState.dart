import 'package:carerstimelogger/unpaidshifts/ShiftDataModel.dart';

abstract class UnpaidShiftsState {}
class LoadingState extends UnpaidShiftsState{}
class LoadedState extends UnpaidShiftsState{
  final List<ShiftDataModel> shifts;

  double get totalHours => shifts.fold(0, (sum, next) => sum + next.hours);

  LoadedState({required this.shifts});
}