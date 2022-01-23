import 'package:carerstimelogger/unpaidshifts/ShiftDataModel.dart';

abstract class UnpaidShiftsState {}
class LoadingState extends UnpaidShiftsState{}
class LoadedState extends UnpaidShiftsState{
  final List<ShiftDataModel> shifts;

  LoadedState({required this.shifts});
}