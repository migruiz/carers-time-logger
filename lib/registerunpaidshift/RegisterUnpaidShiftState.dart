import 'package:carerstimelogger/unpaidshifts/UnpaidShiftsRepository.dart';

import '../CarerData.dart';
import 'package:carerstimelogger/Extensions.dart';

import '../ShiftDataModel.dart';
abstract class RegisterUnpaidShiftState {}
class LoadingState extends RegisterUnpaidShiftState{}
class SavedState extends RegisterUnpaidShiftState{}
class RegisterUnpaidShiftLoadedState extends RegisterUnpaidShiftState{
  final String carerId;
  final DateTime? start;
  final DateTime? end;
  final bool saving;
  final String? shiftId;
  final List<ShiftDataModel> allUnpaidShifts;

  bool get isOverlapping => overlappedShifts.isNotEmpty;
  double get overlappedHours => double.parse((overlappedTime / (1000 * 60 * 60)).toStringAsFixed(1));
  int get overlappedTime => overlappedShifts.values.fold(0, (sum, next) => sum + next);

  bool get isNew => shiftId==null;
  final CarerData carer;
  final Map<ShiftDataModel,int> overlappedShifts = Map();
  void calculateOverlappingShifts(){
    overlappedShifts.clear();
    if (!datesSet){
      return;
    }
    final otherShifts = allUnpaidShifts.where((element) => shiftId==null || (shiftId!=null && element.id!=shiftId!));
    for(final otherShift in otherShifts){
      final overlapInterval = UnpaidShiftsRepository().calculateOverlap(
          myShiftStart: start!,
          myShiftEnd: end!,
          otherShiftStart: otherShift.start,
          otherShiftEnd: otherShift.end
      );
      if (overlapInterval>0){
        overlappedShifts[otherShift] = overlapInterval;
      }
    }
  }

  DateTime get suggestedStart => start??(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, carer.usualStartHour, 0).fromColombianToLocalTime());
  DateTime get suggestedEnd => end??(start!.add(Duration(hours: 12)));
  double get hours => double.parse(((end!.millisecondsSinceEpoch - start!.millisecondsSinceEpoch) / (1000 * 60 * 60)).toStringAsFixed(1));

  bool get startDateTimeSet => start!=null;
  bool get endDateTimeSet => end!=null;
  bool get displayEndDateTimeLine => startDateTimeSet;
  bool get datesSet => startDateTimeSet && endDateTimeSet;
  bool get isValid => datesSet && end!.millisecondsSinceEpoch-start!.millisecondsSinceEpoch>0;

  RegisterUnpaidShiftLoadedState({required this.shiftId,required this.allUnpaidShifts, required this.carer, required this.saving, required this.carerId, required this.start,required this.end});
}