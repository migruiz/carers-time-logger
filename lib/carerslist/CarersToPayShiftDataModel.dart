class CarersToPayShiftDataModel {
  final DateTime start;
  final DateTime end;
  final String id;
  final Map<CarersToPayShiftDataModel,int> overlappedShifts = Map();

  bool get isOverlapping => overlappedShifts.isNotEmpty;

  int get overlappedTime => overlappedShifts.values.fold(0, (sum, next) => sum + next);
  double get overlappedHours => double.parse((overlappedTime / (1000 * 60 * 60)).toStringAsFixed(1));
  int get interval => end.millisecondsSinceEpoch -start.millisecondsSinceEpoch;
  double get hours => double.parse((interval / (1000 * 60 * 60)).toStringAsFixed(1));

  CarersToPayShiftDataModel({required this.id,  required this.start,required this.end});

  void addOverlappedShift(CarersToPayShiftDataModel otherShift, int overlappedInterval) {
    overlappedShifts[otherShift] = overlappedInterval;
  }
}