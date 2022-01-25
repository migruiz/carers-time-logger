import 'package:carerstimelogger/CarerData.dart';
import 'package:carerstimelogger/ShiftDataModel.dart';

import 'MyShiftDataModel.dart';

abstract class UnpaidShiftsState {}
class LoadingState extends UnpaidShiftsState{}
class LoadedState extends UnpaidShiftsState{
  final List<MyShiftDataModel> shifts;
  final CarerData carer;

  bool get isOverlapping => shifts.any((element) => element.isOverlapping);


  double get totalHours => shifts.fold(0, (sum, next) => sum + next.hours);
  double get totalOverlappingHours => shifts.fold(0, (sum, next) => sum + next.overlappedHours  );

  LoadedState({required this.shifts , required this.carer});
}