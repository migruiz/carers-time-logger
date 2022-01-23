class ShiftDataModel {
  final DateTime start;
  final DateTime end;

  double get hours => double.parse(((end.millisecondsSinceEpoch - start.millisecondsSinceEpoch) / (1000 * 60 * 60)).toStringAsFixed(1));

  ShiftDataModel({required this.start,required this.end});
}