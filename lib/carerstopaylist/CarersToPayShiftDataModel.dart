import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsRepository.dart';

import 'OverlapHistoryEntry.dart';

class CarersToPayShiftDataModel {
  final DateTime start;
  final DateTime end;
  final String id;
  final String carerName;
  final Map<CarersToPayShiftDataModel,int> overlappedShifts = Map();

  OverlapInterval getOverlapInterval(CarersToPayShiftDataModel overlapShift){
    final List<OverlapHistoryEntry> list = List.empty(growable: true);
    list.add(OverlapHistoryEntry(carerName: this.carerName, isMe: true, date: this.start));
    list.add(OverlapHistoryEntry(carerName: this.carerName, isMe: true, date: this.end));
    list.add(OverlapHistoryEntry(carerName: overlapShift.carerName, isMe: false, date: overlapShift.start));
    list.add(OverlapHistoryEntry(carerName: overlapShift.carerName, isMe: false, date: overlapShift.end));
    list.sort((a,b) => a.date.compareTo(b.date));

    return OverlapInterval(
      entry1: list[0],
      entry2: list[1],
      entry3: list[2],
      entry4: list[3],
    );
  }

  bool get isOverlapping => overlappedShifts.isNotEmpty;

  int get overlappedTime => overlappedShifts.values.fold(0, (sum, next) => sum + next);
  int get interval => end.millisecondsSinceEpoch -start.millisecondsSinceEpoch;
  double get hours => double.parse((interval / (1000 * 60 * 60)).toStringAsFixed(1));
  double get overlappedHours => double.parse((overlappedTime / (1000 * 60 * 60)).toStringAsFixed(1));

  CarersToPayShiftDataModel({required this.id, required this.carerName,  required this.start,required this.end});

  void addOverlappedShift(CarersToPayShiftDataModel otherShift, int overlappedInterval) {
    overlappedShifts[otherShift] = overlappedInterval;
  }


  void calculateOverlappingShifts(List<CarersToPayShiftDataModel> allUnpaidShifts){
    overlappedShifts.clear();
    final otherShifts = allUnpaidShifts.where((element) => element.id!=id);
    for(final otherShift in otherShifts){
      final overlapInterval = UnpaidShiftsRepository().calculateOverlap(
          myShiftStart: start,
          myShiftEnd: end,
          otherShiftStart: otherShift.start,
          otherShiftEnd: otherShift.end
      );
      if (overlapInterval>0){
        overlappedShifts[otherShift] = overlapInterval;
      }
    }
  }

}