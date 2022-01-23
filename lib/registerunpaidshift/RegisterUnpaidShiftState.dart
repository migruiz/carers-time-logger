class RegisterUnpaidShiftState {
  final DateTime? start;
  final DateTime? end;

  bool get startDateTimeSet => start!=null;
  bool get endDateTimeSet => end!=null;
  bool get displayEndDateTimeLine => startDateTimeSet;
  bool get isValid => startDateTimeSet && endDateTimeSet && end!.millisecondsSinceEpoch-start!.millisecondsSinceEpoch>0;

  RegisterUnpaidShiftState({required this.start,required this.end});
}