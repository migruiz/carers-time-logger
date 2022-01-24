import '../CarerData.dart';

abstract class RegisterUnpaidShiftState {}
class LoadingState extends RegisterUnpaidShiftState{}
class SavedState extends RegisterUnpaidShiftState{}
class RegisterUnpaidShiftLoadedState extends RegisterUnpaidShiftState{
  final String carerId;
  final DateTime? start;
  final DateTime? end;
  final bool saving;
  final CarerData carer;

  DateTime get suggestedEnd => end??(start!.add(Duration(hours: 12)));
  double get hours => double.parse(((end!.millisecondsSinceEpoch - start!.millisecondsSinceEpoch) / (1000 * 60 * 60)).toStringAsFixed(1));

  bool get startDateTimeSet => start!=null;
  bool get endDateTimeSet => end!=null;
  bool get displayEndDateTimeLine => startDateTimeSet;
  bool get datesSet => startDateTimeSet && endDateTimeSet;
  bool get isValid => datesSet && end!.millisecondsSinceEpoch-start!.millisecondsSinceEpoch>0;

  RegisterUnpaidShiftLoadedState({required this.carer, required this.saving, required this.carerId, required this.start,required this.end});
}