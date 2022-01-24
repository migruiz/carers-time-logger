abstract class RegisterUnpaidShiftState {}
class InitState extends RegisterUnpaidShiftState{}
class RegisterUnpaidShiftLoadedState extends RegisterUnpaidShiftState{
  final String carerId;
  final DateTime? start;
  final DateTime? end;

  double get hours => double.parse(((end!.millisecondsSinceEpoch - start!.millisecondsSinceEpoch) / (1000 * 60 * 60)).toStringAsFixed(1));

  bool get startDateTimeSet => start!=null;
  bool get endDateTimeSet => end!=null;
  bool get displayEndDateTimeLine => startDateTimeSet;
  bool get datesSet => startDateTimeSet && endDateTimeSet;
  bool get isValid => datesSet && end!.millisecondsSinceEpoch-start!.millisecondsSinceEpoch>0;

  RegisterUnpaidShiftLoadedState({required this.carerId, required this.start,required this.end});
}