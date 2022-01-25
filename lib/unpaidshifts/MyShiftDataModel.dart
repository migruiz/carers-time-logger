import 'dart:collection';

import 'package:carerstimelogger/ShiftDataModel.dart';

class MyShiftDataModel{
  final DateTime start;
  final DateTime end;
  final String id;
  final Map<ShiftDataModel,int> overlappedShifts = Map();

  int get overlappedTime => overlappedShifts.values.fold(0, (sum, next) => sum + next);
  double get overlappedHours => double.parse((overlappedTime / (1000 * 60 * 60)).toStringAsFixed(1));
  int get interval => end.millisecondsSinceEpoch -start.millisecondsSinceEpoch;
  double get hours => double.parse((interval / (1000 * 60 * 60)).toStringAsFixed(1));

  MyShiftDataModel({required this.id,  required this.start,required this.end});

  void addOverlappedShift(ShiftDataModel otherShift, int overlappedInterval) {
    overlappedShifts[otherShift] = overlappedInterval;
  }
}