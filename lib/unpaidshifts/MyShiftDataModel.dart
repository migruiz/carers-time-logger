import 'package:carerstimelogger/ShiftDataModel.dart';

class MyShiftDataModel{
  final DateTime start;
  final DateTime end;
  final String id;
  final List<ShiftDataModel> overlappedShifts = List.empty(growable: true);

  double get hours => double.parse(((end.millisecondsSinceEpoch - start.millisecondsSinceEpoch) / (1000 * 60 * 60)).toStringAsFixed(1));

  MyShiftDataModel({required this.id,  required this.start,required this.end});

  void addOverlappedShift(ShiftDataModel otherShift) {
    overlappedShifts.add(otherShift);
  }
}